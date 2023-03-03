cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-02_core LANGUAGES CXX)

# 这是我们自己的代码，需要使用boost库

find_package(Boost 1.61 REQUIRED COMPONENTS filesystem)
get_property(_loc TARGET Boost::filesystem PROPERTY LOCATION)
message(STATUS "Found BOOST: ${_loc} (found version ${BOOST_VERSION})")

add_executable(path-info path-info.cpp)

target_link_libraries(path-info
  PUBLIC
    Boost::filesystem
  )
