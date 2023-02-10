# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(cmake-lan-std LANGUAGES CXX)

# 要求在windows上导出所有库符号
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS NO)

add_library(animals
  SHARED
    Animal.cpp
    Animal.hpp
    Cat.cpp
    Cat.hpp
    Dog.cpp
    Dog.hpp
    Factory.hpp
  )

# 设置语言标准
# CXX_STANDARD 设置我们想要的标准
# CXX_EXTENSIONS 只启用ISO C++标准的编译器标志，而不使用特定编译器的扩展
# CXX_STANDARD_REQUIRED 指定所选标准的版本，不可以则停止配置并出错。不开启则寻找下一个标准的最新版本
# 如果语言标准是所有目标全局共享的，可以设置CMAKE_<LANG>_STANDARD, CMAKE_<LANG>_EXTENSIONS, CMAKE_<LANG>_STANDARD_REQUIRED
# also see cmake-compile-features
# https://cmake.org/cmake/help/latest/manual/cmake-compile-features.7.html
set_target_properties(animals
  PROPERTIES
    CXX_STANDARD 14
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE 1
  )

add_executable(animal-farm animal-farm.cpp)

set_target_properties(animal-farm
  PROPERTIES
    CXX_STANDARD 14
    CXX_EXTENSIONS OFF
    CXX_STANDARD_REQUIRED ON
  )

target_link_libraries(animal-farm animals)
