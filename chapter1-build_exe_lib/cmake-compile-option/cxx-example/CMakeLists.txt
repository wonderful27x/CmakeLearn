cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-compile-option LANGUAGES CXX)

message("C++ compiler flags: ${CMAKE_CXX_FLAGS}")

list(APPEND flags "-fPIC" "-Wall")
if(NOT WIN32)
    list(APPEND flags "-Wextra" "-Wpedantic")
endif()

add_library(geometry
    STATIC
        geometry_circle.cpp
        geometry_circle.hpp
        geometry_polygon.cpp
        geometry_polygon.hpp
        geometry_rhombus.cpp
        geometry_rhombus.hpp
        geometry_square.cpp
        geometry_square.hpp
    )

# 设置编译器标志, 相比于使用cmake命令: cmake -D CMAKE_CXX_FLAGS宏作全局修改，
# 可以单独控制每一个库
target_compile_options(geometry
    PRIVATE
        ${flags}
    )

add_executable(compute-areas compute-areas.cpp)

# 设置编译器标志
target_compile_options(compute-areas
    PRIVATE
        "-fPIC"
    )

target_link_libraries(compute-areas geometry)


