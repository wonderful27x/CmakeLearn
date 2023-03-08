# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-07 LANGUAGES CXX)

# require C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# example code
add_executable(example example.cpp)

# needs to find the generated header file
target_include_directories(example
  PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/generated
  )

# 自定义命令通过cmake调用了一个cmake脚本，这个脚本使用git命令获取git-hash并生成了头文件
add_custom_command(
  OUTPUT
    ${CMAKE_CURRENT_BINARY_DIR}/generated/version.hpp
    ALL
  COMMAND
    ${CMAKE_COMMAND} -D TARGET_DIR=${CMAKE_CURRENT_BINARY_DIR} -P ${CMAKE_CURRENT_SOURCE_DIR}/git-hash.cmake
  WORKING_DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR}
  )

# # rebuild version.hpp every time
# # 定义一个ALL目标，ALL参数将使目标始终被执行,并将自定义命令的输出DEPENDS依赖进来
# # 以此保证每次构建时重新生成
add_custom_target(
  get_git_hash
  ALL
  DEPENDS
    ${CMAKE_CURRENT_BINARY_DIR}/generated/version.hpp
  COMMENT
    "custom target running"
  )

# version.hpp has to be generated
# before we start building example
# 因为编译example需要version.h头文件，所以在编译之前应该生成它
# 将get_git_hash设置为example使得调用关系正确
add_dependencies(example get_git_hash)
