# 指定cmake最小版本号，小于则停止并报错
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# 定义项目名称，以及支持的语言
project(vim LANGUAGES C)

# 默认release版本
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# CMAKE_INSTALL_PREFIX 自定义安装位置，cmake的所有安装地址都是相对于这个地址的
# 用户可以使用cmake -DCMAKE_INSTALL_PREFIX=xxx指定
# 默认情况：Windows上的C:\Program Files和Unix上的/usr/local
message(STATUS "Project will be installed to ${CMAKE_INSTALL_PREFIX}")

# 设置构建输出目录
include(GNUInstallDirs)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})

# Offer the user the choice of overriding the installation directories
# 设置安装目录，相对于CMAKE_INSTALL_PREFIX
# 测试时INSTALL_LIBDIR: lib
# INSTALL_BINDIR: bin
# 因此我们可以推测上面设置的时编译后的库的输出目录
# 安装时将文件复制到了指定的安装目录
set(INSTALL_LIBDIR ${CMAKE_INSTALL_LIBDIR} CACHE PATH "Installation directory for libraries")
set(INSTALL_BINDIR ${CMAKE_INSTALL_BINDIR} CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDEDIR ${CMAKE_INSTALL_INCLUDEDIR} CACHE PATH "Installation directory for header files")
# INSTALL_CMAKEDIR在后面的章节介绍
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKEDIR CMake)
else()
  set(DEF_INSTALL_CMAKEDIR share/cmake/${PROJECT_NAME})
endif()
set(INSTALL_CMAKEDIR ${DEF_INSTALL_CMAKEDIR} CACHE PATH "Installation directory for CMake files")

# 在向配置添加任何目标之前，通常有必要看看传统构建的行为,
# 并将配置和构建步骤的输出保存到日志文件中, 从而查看编译了哪些源文件以及使用了哪些编译标志
# 使用./configure --help，列出用户可用的选项，会有很多，我们这里选择三个作为演示
option(ENABLE_NETBEANS "Enable netbeans" ON)
option(ENABLE_CHANNEL "Enable channel" ON)
option(ENABLE_TERMINAL "Enable terminal" ON)

# 我们可以用cmake -D FEATURES=value定义的变量FEATURES来模拟--with-features 标志
# 设置FEATURES 默认为huge
if(NOT FEATURES)
    set(FEATURES "huge" CACHE STRING "FEATURES chosen by the user at CMake configure time")
endif()
# 对FEATURES进行检查
# make sure the selected features is a valid choice
list(APPEND _available_features "tiny" "small" "normal" "big" "huge")
if(NOT FEATURES IN_LIST _available_features)
  message(FATAL_ERROR "Unknown features: \"${FEATURES}\". Allowed values are: ${_available_features}.")
endif()
# 当使用cmake-gui配置项目，则有有不错的效果，用户可根据选择字段清单，选择已经定义了的FEATURES
set_property(CACHE FEATURES PROPERTY STRINGS ${_available_features})

# enable test
enable_testing()

# 添加子项目
add_subdirectory(src)
