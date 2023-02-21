cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(recipe-07 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 本例子用于检查编译器标志是否可用, 主要使用sanitize来测试,
# asan是一个有用的代码分析工具，可用于内存缺陷检测等

# 设置通用的标志
list(APPEND CXX_BASIC_FLAGS "-g3" "-O1")

# 引入CheckCXXCompilerFlag模块
include(CheckCXXCompilerFlag)

set(ASAN_FLAGS "-fsanitize=address -fno-omit-frame-pointer")
# check_cxx_compiler_flag函数用于检测编译器是否理解一组标志，check_cxx_compiler_flag 是 check_cxx_source_compiles的封装
# 此外,Sanitize的这组标志需要设置给连接器，调用check_cxx_compiler_flag之前先设置标志CMAKE_REQUIRED_FLAGS,
# 否则标志检测只对编译器起作用, 导致假阴性
set(CMAKE_REQUIRED_FLAGS ${ASAN_FLAGS})
check_cxx_compiler_flag(${ASAN_FLAGS} asan_works)
# 检测完成后取消标志
unset(CMAKE_REQUIRED_FLAGS)
# 检测成功后将标志设置到编译器和连接器
if(asan_works)
  string(REPLACE " " ";" _asan_flags ${ASAN_FLAGS})
  add_executable(asan-example asan-example.cpp)
  target_compile_options(asan-example
    PUBLIC
      ${CXX_BASIC_FLAGS}
      ${_asan_flags}
    )
  target_link_libraries(asan-example
    PUBLIC
      ${_asan_flags}
    )
endif()

set(TSAN_FLAGS "-fsanitize=thread -fno-omit-frame-pointer -fPIE")
set(CMAKE_REQUIRED_FLAGS ${TSAN_FLAGS})
check_cxx_compiler_flag(${TSAN_FLAGS} tsan_works)
unset(CMAKE_REQUIRED_FLAGS)
if(tsan_works)
  string(REPLACE " " ";" _tsan_flags ${TSAN_FLAGS})
  find_package(Threads REQUIRED)
  add_executable(tsan-example tsan-example.cpp)
  target_compile_options(tsan-example
    PUBLIC
      ${CXX_BASIC_FLAGS}
      ${_tsan_flags}
    )
  target_link_libraries(tsan-example
    PUBLIC
      Threads::Threads
      ${_tsan_flags}
      -pie
    )
endif()

set(MSAN_FLAGS "-fsanitize=memory -fno-omit-frame-pointer -fPIE")
set(CMAKE_REQUIRED_FLAGS ${MSAN_FLAGS})
check_cxx_compiler_flag(${MSAN_FLAGS} msan_works)
unset(CMAKE_REQUIRED_FLAGS)
if(msan_works)
  string(REPLACE " " ";" _msan_flags ${MSAN_FLAGS})
  add_executable(msan-example msan-example.cpp)
  target_compile_options(msan-example
    PUBLIC
      ${CXX_BASIC_FLAGS}
      ${_msan_flags}
    )
  target_link_libraries(msan-example
    PUBLIC
      ${_msan_flags}
      -pie
    )
endif()

set(UBSAN_FLAGS "-fsanitize=undefined -fno-omit-frame-pointer")
set(CMAKE_REQUIRED_FLAGS ${UBSAN_FLAGS})
check_cxx_compiler_flag(${UBSAN_FLAGS} ubsan_works)
unset(CMAKE_REQUIRED_FLAGS)
if(ubsan_works)
  string(REPLACE " " ";" _ubsan_flags ${UBSAN_FLAGS})
  add_executable(ubsan-example ubsan-example.cpp)
  target_compile_options(ubsan-example
    PUBLIC
      ${CXX_BASIC_FLAGS}
      ${_ubsan_flags}
    )
endif()
