cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-custom-target LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 定义一个自定义目标unpack-eigen，用于解压一个库文件包
# 此目标可以被其他目标依赖, 也可以依赖其他目标
# ALL 参数目标将始终被执行
# COMMAND 指定要执行的命令
# -E 标志调用CMake命令本身来执行，这通常是跨平台的
# WORKING_DIRECTORY指定执行命令的工作目录
# COMMAND用于指定执行自定义目标的输出
add_custom_target(unpack-eigen
  ALL
  COMMAND
    ${CMAKE_COMMAND} -E tar xzf ${CMAKE_CURRENT_SOURCE_DIR}/eigen-eigen-5a0156e40feb.tar.gz
  COMMAND
    ${CMAKE_COMMAND} -E rename eigen-eigen-5a0156e40feb eigen-3.3.4
  WORKING_DIRECTORY
    ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT
    "Unpacking Eigen3 in ${CMAKE_CURRENT_BINARY_DIR}/eigen-3.3.4"
  )

add_executable(linear-algebra linear-algebra.cpp)

# 添加对自定义目标的依赖
add_dependencies(linear-algebra unpack-eigen)

target_include_directories(linear-algebra
  PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/eigen-3.3.4
  )
