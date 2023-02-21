# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# 生成版本信息并在可执行文件中打印，这通常是非常有用的
# 从文件中读取版本号

# project name and language
project(recipe-04 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# read version from file
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/VERSION")
    file(READ "${CMAKE_CURRENT_SOURCE_DIR}/VERSION" PROGRAM_VERSION)
    # 去除尾后空格
    string(STRIP "${PROGRAM_VERSION}" PROGRAM_VERSION)
else()
    message(FATAL_ERROR "File ${CMAKE_CURRENT_SOURCE_DIR}/VERSION not found")
endif()

# generate file version.h based on version.h.in
configure_file(
  version.h.in
  generated/version.hpp
  @ONLY
  )

# NOTE:CMake以x.y.z格式给出的版本号，并将变量PROJECT_VERSION和 <project-name>_VERSION设置为给定的值。此外,PROJECT_VERSION_MAJOR(<project-name>_VERSION_MAJOR),PROJECT_VERSION_MINOR(<project-name>_VERSION_MINOR) PROJECT_VERSION_PATCH(<project-name>_VERSION_PATCH)和PROJECT_VERSION_TWEAK(<project-name>_VERSION_TWEAK),将分别设置为X, Y, Z和t。

# example code
add_executable(example example.cpp)

# needs to find the generated header file
target_include_directories(example
  PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/generated
  )
