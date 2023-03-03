# CMake 3.6 needed for IMPORTED_TARGET option
# to pkg_search_module
cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(recipe-03
  LANGUAGES CXX
  VERSION 1.0.0
  )

# 导出目标，编译并安装一个库，使得后续可以使用find_package查找和使用它

# <<< General set up >>>

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 设置安装目录前缀目录
message(STATUS "Project will be installed to ${CMAKE_INSTALL_PREFIX}")

# 构建类型release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

message(STATUS "Build type set to ${CMAKE_BUILD_TYPE}")

include(GNUInstallDirs)

# 设置构建输出目录, 即build时的输出目录
# 如库输出在lib, 头文件在include，可执行文件在bin
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

# 设置安装目录，即install时的目录，相对于CMAKE_INSTALL_PREFIX
# Offer the user the choice of overriding the installation directories
set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "Installation directory for libraries")
set(INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR} CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE PATH "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKEDIR CMake)
else()
  set(DEF_INSTALL_CMAKEDIR share/cmake/${PROJECT_NAME})
endif()
# 设置cmake配置文件安装目录
# 正确安装message库后生成.cmake文件用于find_package的查找，
# 而这些.cmake文件就是安装在下面这个目录INSTALL_CMAKEDIR
set(INSTALL_CMAKEDIR ${DEF_INSTALL_CMAKEDIR} CACHE PATH "Installation directory for CMake files")

# Report to user
# 打印信息
foreach(p LIB BIN INCLUDE CMAKE)
  file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX}/${INSTALL_${p}DIR} _path )
  message(STATUS "Installing ${p} components to ${_path}")
  unset(_path)
endforeach()

# 这里注意理解
# 在src中我们通过源码编译了message库，然后又添加了我们的可执行文件依赖于message
# 然后我们将message生成了一个导出目标，并进行了安装
# cmake -H. -Bbuild -DCMAKE_INSTALL_DIR=./build_install
# cmake --build build --target install
add_subdirectory(src)

enable_testing()

# cmake --build build --target test
# 接下来我们在test中进行测试，我们仍然需要依赖message，
# 又由于上面生成了message的导出目标，所有我们使用find_package命令从安装位置查找message
# 而不是像之前那样直接使用message编译的库
# 如果没有这个导出目标，我们是无法使用find_package定位的，因为根本就没有FindMessageConfig.cmake模块
# 然而需要注意的是我们需要使用cmake -Dmessage_DIR指定messageConfig.cmake的路径
# 详细情况看tests
add_subdirectory(tests)
