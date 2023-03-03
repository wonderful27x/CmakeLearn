# CMake 3.6 needed for IMPORTED_TARGET option
# to pkg_search_module
cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(recipe-01
  LANGUAGES CXX
  VERSION 1.0.0
  )

# <<< General set up >>>

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# CMAKE_INSTALL_PREFIX 自定义安装位置，cmake的所有安装地址都是相对于这个地址的
# 用户可以使用cmake -DCMAKE_INSTALL_PREFIX=xxx指定
# 默认情况：Windows上的C:\Program Files和Unix上的/usr/local
message(STATUS "Project will be installed to ${CMAKE_INSTALL_PREFIX}")

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

message(STATUS "Build type set to ${CMAKE_BUILD_TYPE}")

include(GNUInstallDirs)

# 设置执行、静态和动态库目标构建的输出位置，让用户在不安装时也能找到
# 使用GNUInstallDirs.cmake模块,这将确保的项目布局的合理性和可移植性
# CMAKE_INSTALL_BINDIR：这将用于定义用户可执行文件所在的子目录，即所选安装目录下的bin目录。
# CMAKE_INSTALL_LIBDIR：这将扩展到目标代码库(即静态库和动态库)所在的子目录。在64位系统上，它是lib64，而在32位系统上，它只是lib。
# CMAKE_INSTALL_INCLUDEDIR：最后，我们使用这个变量为C头文件获取正确的子目录，该变量为include。
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/${CMAKE_INSTALL_BINDIR})
message(STATUS "静态库构建输出目录: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} \n
PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR} CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "动态库构建输出目录: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY} \n
PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR} CMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}")
message(STATUS "可执行文件构建输出目录: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} \n
PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR} CMAKE_INSTALL_BINDIR: ${CMAKE_INSTALL_BINDIR}")

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

# 向用户报告安装位置
# TO_NATIVE_PATH将cmake风格的路径转换为操作系统特定风格的路径表式形式
# Report to user
foreach(p LIB BIN INCLUDE CMAKE)
  file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX}/${INSTALL_${p}DIR} _path )
  message(STATUS "Installing ${p} components to ${_path}")
  unset(_path)
endforeach()

add_subdirectory(src)

enable_testing()

add_subdirectory(tests)
