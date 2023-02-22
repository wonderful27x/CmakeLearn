cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-03 LANGUAGES C CXX)

# 模块用于检测编译器标志，注意这只是一个例子，他返回第一个测试通过的标志
include(set_compiler_flag.cmake)

set_compiler_flag(
  working_compile_flag C REQUIRED
  "-foo"             # this should fail
  "-wrong"           # this should fail
  "-wrong"           # this should fail
  "-Wall"            # this should work with GNU
  "-warn all"        # this should work with Intel
  "-Minform=inform"  # this should work with PGI
  "-nope"            # this should fail
  )

message(STATUS "working C compile flag: ${working_compile_flag}")

set_compiler_flag(
  working_compile_flag CXX REQUIRED
  "-foo"    # this should fail
  "-g"      # this should work with GNU, Intel, PGI
  "/RTCcsu" # this should work with MSVC
  )

message(STATUS "working CXX compile flag: ${working_compile_flag}")
