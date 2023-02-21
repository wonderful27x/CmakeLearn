cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(cmake-compile-option LANGUAGES CXX)

message("C++ compiler flags: ${CMAKE_CXX_FLAGS}")

# 有些标志可能是特定编译器独有的，所以需要区分编译器
# if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
#   list(APPEND CMAKE_CXX_FLAGS "-fno-rtti" "-fno-exceptions")
#   list(APPEND CMAKE_CXX_FLAGS_DEBUG "-Wsuggest-final-types" "-Wsuggest-final-methods" "-Wsuggest-override")
#   list(APPEND CMAKE_CXX_FLAGS_RELEASE "-O3" "-Wno-unused")
# endif()
# if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
#   list(APPEND CMAKE_CXX_FLAGS "-fno-rtti" "-fno-exceptions" "-Qunused-arguments" "-fcolor-diagnostics")
#   list(APPEND CMAKE_CXX_FLAGS_DEBUG "-Wdocumentation")
#   list(APPEND CMAKE_CXX_FLAGS_RELEASE "-O3" "-Wno-unused")
# endif()

# 更细致的设置, 缺点是CMAKE_CXX_COMPILER_ID不是所有语言和供应商都提供的，see check-and-set
# set(COMPILER_FLAGS)
# set(COMPILER_FLAGS_DEBUG)
# set(COMPILER_FLAGS_RELEASE)

if(CMAKE_CXX_COMPILER_ID MATCHES GUN)
    list(APPEND CXX_FLAGS "-fno-rtti" "-fno-exceptions")
    list(APPEND CXX_FLAGS_DEBUG "-Wsuggest-final-types" "-Wsuggest-final-methods" "-Wsuggest-override")
    list(APPEND CXX_FLAGS_RELEASE "-O3" "-Wno-unused")
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES Clang)
  list(APPEND CXX_FLAGS "-fno-rtti" "-fno-exceptions" "-Qunused-arguments" "-fcolor-diagnostics")
  list(APPEND CXX_FLAGS_DEBUG "-Wdocumentation")
  list(APPEND CXX_FLAGS_RELEASE "-O3" "-Wno-unused")
endif()

add_library(geometry
    STATIC
        ../geometry_circle.cpp
        ../geometry_circle.hpp
        ../geometry_polygon.cpp
        ../geometry_polygon.hpp
        ../geometry_rhombus.cpp
        ../geometry_rhombus.hpp
        ../geometry_square.cpp
        ../geometry_square.hpp
    )

list(APPEND flags "-fPIC" "-Wall")
if(NOT WIN32)
  list(APPEND flags "-Wextra" "-Wpedantic")
endif()

# 设置编译器标志, 相比于使用cmake命令: cmake -D CMAKE_CXX_FLAGS宏作全局修改，
# 可以单独控制每一个库
target_compile_options(geometry
    PRIVATE
        ${flags}
    )

add_executable(compute-areas ../compute-areas.cpp)

# 设置编译器标志
target_compile_options(compute-areas
    PRIVATE
        ${CXX_FLAGS}
        "$<$<CONFIG:Debug>:${CXX_FLAGS_DEBUG}>"
        "$<$<CONFIG:Release>:${CXX_FLAGS_RELEASE}>"
    )

target_link_libraries(compute-areas geometry)


