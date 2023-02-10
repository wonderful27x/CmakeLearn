cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-lib LANGUAGES CXX)

add_library(message
    STATIC
    message.h
    message.cpp
    )

add_executable(hello-cmake hello-cmake.cpp)

target_link_libraries(hello-cmake message)
