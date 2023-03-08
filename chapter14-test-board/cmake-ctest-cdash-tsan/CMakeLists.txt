# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-04 LANGUAGES CXX)

# 使用TSAN检测多线程数据竞争问题

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Threads REQUIRED)

add_executable(example example.cpp)

# 线程库
target_link_libraries(example
  PUBLIC
    Threads::Threads
  )

# TSAN开关
option(ENABLE_TSAN "Enable ThreadSanitizer" OFF)

if(ENABLE_TSAN)
  if(CMAKE_CXX_COMPILER_ID MATCHES GNU)
    message(STATUS "ThreadSanitizer enabled")
    target_compile_options(example
      PUBLIC
        -g -O1 -fsanitize=thread -fno-omit-frame-pointer -fPIC
      )
    target_link_libraries(example
      PUBLIC
        tsan
      )
  else()
    message(WARNING "ThreadSanitizer not supported for this compiler")
  endif()
endif()

enable_testing()

# allow to report to a cdash dashboard
include(CTest)

# 添加test
add_test(
  NAME
    example
  COMMAND
    $<TARGET_FILE:example>
  )
