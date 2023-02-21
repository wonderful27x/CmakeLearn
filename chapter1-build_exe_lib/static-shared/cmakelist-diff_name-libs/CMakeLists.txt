cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-libs-object LANGUAGES CXX)

add_library(message-objs
    OBJECT
        ../message.cpp
        ../message.h
    )

set_target_properties(message-objs
    PROPERTIES
        POSITION_INDEPENDENT_CODE 1
    )

add_library(message-shared
    SHARED
        $<TARGET_OBJECTS:message-objs>
    )

add_library(message-static
    SHARED
        $<TARGET_OBJECTS:message-objs>
    )

add_executable(hello-cmake ../hello-cmake.cpp)

target_link_libraries(hello-cmake message-static)



