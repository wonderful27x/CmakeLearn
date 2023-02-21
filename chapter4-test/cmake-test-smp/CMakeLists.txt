cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-test LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(PythonInterp REQUIRED)
find_program(BASH_EXECUTABLE NAMES bash REQUIRED)

# example library
add_library(sum_integers sum_integers.cpp)

# main code
add_executable(sum_up main.cpp)
target_link_libraries(sum_up sum_integers)

# test binary
add_executable(cpp_test test.cpp)
target_link_libraries(cpp_test sum_integers)

# 测试这个目录和所有子文件夹（相对CMakeLists.txt)
enable_testing()

# define tests
add_test(
    NAME bash_test
    COMMAND ${BASH_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.sh $<TARGET_FILE:sum_up>
    )

# NAME 指定测试名称
# $<TARGET_FILE:cpp_test>是生成器表达式,将使用cpp_test可执行文件完整路径进行替换
add_test(
    NAME cpp_test
    COMMAND $<TARGET_FILE:cpp_test>
    )

# 名称可以包含/,这在分组时非常有用
# 可用--传递参数
add_test(
    NAME python/long
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/test.py --executable $<TARGET_FILE:sum_up>
    )

# 可以使用WORKING_DIRECTORY指定目录
add_test(
    NAME python_test_short
    COMMAND ${PYTHON_EXECUTABLE} test.py --short --executable $<TARGET_FILE:sum_up>
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )


