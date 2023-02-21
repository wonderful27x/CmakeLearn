cmake_minimum_required(VERSION 3.9 FATAL_ERROR)

project(recipe-06 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 测试编译和链接
# 可以使用try_compile 和 check_cxx_source_compiles
# 两种方式，后者使前者的封装简化, 小的代码片段可以使用后者，否则建议使用前者
# try_compile和check_cxx_source_compiles都将编译源文件，并将其链接到可执行文件中
# 主要测试一下内容:
# 如何确保代码能成功编译为可执行文件。
# 如何确保编译器理解相应的标志。
# 如何确保特定代码能成功编译为运行可执行程序。

find_package(OpenMP)

if(OpenMP_FOUND)
  # this will get wiped unless you run cmake with --debug-trycompile
  
  # 设置一个目录用于保存try_compile的中间文件，不使用 --debug-try_compile
  # 目录将自动被删除
  set(_scratch_dir ${CMAKE_CURRENT_BINARY_DIR}/omp_try_compile)

  # 使用try_compile
  # 调用try_compile生成一个小项目，以尝试编译源文件taskloop.cpp。成功或失败将保存到omp_taskloop_test_1变量中, 注意OpenMP::OpenMP_CXX包括了编译器标志的设置
  try_compile(
    omp_taskloop_test_1
    ${_scratch_dir}
    SOURCES
      ${CMAKE_CURRENT_SOURCE_DIR}/taskloop.cpp
    LINK_LIBRARIES
      OpenMP::OpenMP_CXX
    )
  message(STATUS "Result of try_compile: ${omp_taskloop_test_1}")

  # 使用check_cxx_source_compiles
  # file命令将要测试的代码片段读入变量_snippet
  include(CheckCXXSourceCompiles)
  file(READ ${CMAKE_CURRENT_SOURCE_DIR}/taskloop.cpp _snippet)
  # 测试前设置要测试的编译器标志
  # 这些标志有：
  # CMAKE_REQUIRED_FLAGS：设置编译器标示。
  # CMAKE_REQUIRED_DEFINITIONS：设置预编译宏。
  # CMAKE_REQUIRED_INCLUDES：设置包含目录列表。
  # CMAKE_REQUIRED_LIBRARIES：设置可执行目标能够连接的库列表。
  set(CMAKE_REQUIRED_LIBRARIES OpenMP::OpenMP_CXX)
  # 调用check_cxx_source_compiles进行测试，
  check_cxx_source_compiles("${_snippet}" omp_taskloop_test_2)
  # 测试后必须手动清除
  unset(CMAKE_REQUIRED_LIBRARIES)
  message(STATUS "Result of check_cxx_source_compiles: ${omp_taskloop_test_2}")
else()
  message(STATUS "OpenMP not found: no test for taskloop is run")
endif()
