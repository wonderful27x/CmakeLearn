# Search for pkg-config and UUID
find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_search_module(UUID uuid IMPORTED_TARGET)
  if(TARGET PkgConfig::UUID)
    message(STATUS "Found libuuid")
    set(UUID_FOUND TRUE)
  endif()
endif()

# <<< Build targets >>>

# 添加动态库
# SHARED library
add_library(message-shared SHARED "")

target_sources(message-shared
  PRIVATE
    ${CMAKE_CURRENT_LIST_DIR}/Message.cpp
  )

target_compile_definitions(message-shared
  PUBLIC
    $<$<BOOL:${UUID_FOUND}>:HAVE_UUID>
  )

target_link_libraries(message-shared
  PUBLIC
    $<$<BOOL:${UUID_FOUND}>:PkgConfig::UUID>
  )

# 设置属性，POSITION_INDEPENDENT_CODE 1设置于位置无关的代码，见-fpic
set_target_properties(message-shared
  PROPERTIES
    POSITION_INDEPENDENT_CODE 1
    # 动态库版本
    SOVERSION ${PROJECT_VERSION_MAJOR}
    # 库名
    OUTPUT_NAME "message"
    # 以Debug配置构建项目，则将_d后缀添加到生成的动态库
    DEBUG_POSTFIX "_d"
    # 头文件，后面在安装时会用到
    PUBLIC_HEADER "Message.hpp"
    MACOSX_RPATH ON
    # 这将强制在Windows上编译以导出所有符号,这不是一个好的方法
    WINDOWS_EXPORT_ALL_SYMBOLS ON
  )
message(STATUS "PUBLIC_HEADER: ${PUBLIC_HEADER}")
# MACOSX_RPATH: 这将动态库的install_name部分(目录)设置为macOS上的@rpath。
# PUBLIC_HEADER: 我们使用这个属性来设置头文件列表(本例中只有一个头文件)，声明提供的API函数。这主要用于macOS上的动态库目标，也可以用于其他操作系统和目标。有关详细信息，请参见官方文档:https://cmake.org/cmake/help/v3.6/prop_tgt/PUBLIC_HEADER.html

# EXECUTABLES
add_executable(hello-world_wDSO hello-world.cpp)

target_link_libraries(hello-world_wDSO
  PUBLIC
    message-shared
  )

# 什么是RPATH?
# 可执行文件在执行时需要加载动态库，因此需要知道动态库的位置, 库的定位有两种方法:
# 1. 通过设置环境变量通知链接器:
#    GNU/Linux上，这需要将路径附加到LD_LIBRARY_PATH环境变量中。注意，这很可能会污染系统中所有应用程序的链接器路径，并可能导致符号冲突( https://gms.tf/ld_library_path-considered-harmful.htm )。
#    macOS上，可以设置DYLD_LIBRARY_PATH变量。这与GNU/Linux上的LD_LIBRARY_PATH有相同的问题，可以通过使用DYLD_FALLBACK_LIBRARY_PATH变量来(部分的)改善这种情况。请看下面的链接，获取相关例子: https://stackoverflow.com/a/3172515/2528668
# 2. 可被编码到可执行文件中，使用RPATH可以设置可执行文件的运行时搜索路径
# 后一种方法更健壮。但是，设置动态对象的RPATH时，应该选择哪个路径？我们需要确保可执行文件总是找到正确的动态库，不管它是在构建树中运行还是在安装树中运行。这需要通过设置 hello-world_wDSO目标的RPATH相关属性来实现的，通过$ORIGIN(在GNU/Linux上)或@loader_path(在macOS上)变量来查找与可执行文件本身位置相关的路径:

# Prepare RPATH
file(RELATIVE_PATH _rel ${CMAKE_INSTALL_PREFIX}/${INSTALL_BINDIR} ${CMAKE_INSTALL_PREFIX})
message(STATUS "RELATIVE_PATH: ${_rel}")
if(APPLE)
  set(_rpath "@loader_path/${_rel}")
else()
  set(_rpath "\$ORIGIN/${_rel}")
endif()
file(TO_NATIVE_PATH "${_rpath}/${INSTALL_LIBDIR}" message_RPATH)
message(STATUS "message rpath: ${message_RPATH}")

set_target_properties(hello-world_wDSO
  PROPERTIES
    MACOSX_RPATH ON
    # 诉CMake生成适当的RPATH，以便能够在构建树中运行可执行文件。
    SKIP_BUILD_RPATH OFF
    # 关闭生成可执行目标，使其RPATH调整为与安装树的RPATH相同。在构建树中不运行可执行文件。
    BUILD_WITH_INSTALL_RPATH OFF
    # 将已安装的可执行目标的RPATH设置为先前的路径。
    INSTALL_RPATH "${message_RPATH}"
    # 告诉CMake将链接器搜索路径附加到可执行文件的RPATH中。
    INSTALL_RPATH_USE_LINK_PATH ON
  )

# <<< Install and export targets >>>
# 安装，库和可执行文件都是构建目标，所以可以使用target指定
install(
  TARGETS
    message-shared
    hello-world_wDSO
  # 静态库
  ARCHIVE
    DESTINATION ${INSTALL_LIBDIR}
    COMPONENT lib
  # 可执行文件
  RUNTIME
    DESTINATION ${INSTALL_BINDIR}
    COMPONENT bin
  # 动态库
  LIBRARY
    DESTINATION ${INSTALL_LIBDIR}
    COMPONENT lib
  # 头文件
  PUBLIC_HEADER
    DESTINATION ${INSTALL_INCLUDEDIR}/message
    COMPONENT dev
  )
# COMPONENT可以用于有选择的部分安装，而不是安装所有文件，如果只安装库
# cmake -D COMPONENT=lib -P cmake_install.cmake

# 当使用cmake --build . --target install，路径将相对于CMAKE_INSTALL_PREFIX计算。但当使用CPack时，绝对路径将相对于CPACK_PACKAGING_INSTALL_PREFIX计算。

# 在构建树中运行ldd查看可执行文件的链接库路径:
# libmessage.so.1 => /home/roberto/Workspace/robertodr/cmake-cookbook/chapter-10/recipe-01/cxx-example/build/lib64/libmessage.so.1 (0x00007f7a92e44000)
# 在安装目录下，我们得到:
# libmessage.so.1 => /home/roberto/Software/ch10r01/bin/../lib64/libmessage.so.1 (0x00007fbd2a725000)

# 我们使用了带有目标参数的CMake安装命令，因为我们需要安装构建目标。而该命令还有另外4个参数:
# FILES和PROGRAMS，分别用于安装文件或程序。安装后，并设置安装文件适当的权限。对于文件，对所有者具有读和写权限，对组以及其他用户和组具有读权限。对于程序，将授予执行权限。注意，PROGRAMS要与非构建目标的可执行程序一起使用。参见: https://cmake.org/cmake/help/v3.6/command/install.html#installing-files
# DIRECTORY，用于安装目录。当只给出一个目录名时，它通常被理解为相对于当前源目录。可以对目录的安装粒度进行控制。请参考在线文档： https://cmake.org/cmake/help/v3.6/command/install.html#installing-directories
# SCRIPT，可以使用它在CMake脚本中定义自定义安装规则。参见： https://cmake.org/cmake/help/v3.6/command/install.html#custom-installation-logic
# EXPORT，我们将此参数的讨论推迟到第3节，该参数用于导出目标。
