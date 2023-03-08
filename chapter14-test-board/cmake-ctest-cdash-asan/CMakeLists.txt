# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-03 LANGUAGES CXX)
                  
# require C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# process src/CMakeLists.txt
# 构建buggy库
# 内部由asan的启用开关
add_subdirectory(src)

enable_testing()

# allow to report to a cdash dashboard
# 向cdash报告测试结果
include(CTest)

# 添加了对buggy库的测试测试
# process tests/CMakeLists.txt
add_subdirectory(tests)
