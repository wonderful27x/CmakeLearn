cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(recipe-09 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 使用PkgConfig来检测包
# 当找到pkg-config时, CMake需要提供两个函数，来封装这个程序提供的功能:
# pkg_check_modules，查找传递列表中的所有模块(库和/或程序)
# pkg_search_module，要在传递的列表中找到第一个工作模块
find_package(PkgConfig REQUIRED QUIET)

pkg_search_module(
  ZeroMQ
  REQUIRED
    libzeromq libzmq lib0mq
  IMPORTED_TARGET
  )

if(TARGET PkgConfig::ZeroMQ)
  message(STATUS "Found ZeroMQ")
endif()

add_executable(hwserver hwserver.c)

target_link_libraries(hwserver PkgConfig::ZeroMQ)

add_executable(hwclient hwclient.c)

target_link_libraries(hwclient PkgConfig::ZeroMQ)
