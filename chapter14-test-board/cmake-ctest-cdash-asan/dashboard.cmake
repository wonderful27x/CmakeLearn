# 这是一个用于向cdash报告的cmake脚本
# 注意在前面的例子中我们直接使用--target Experimental
# 这里我们将使用我们自己的脚本ctest -S dashboard.cmake
# 设置一些信息
message(STATUS "run dashboard.cmake for ctest cdash board")
set(CTEST_PROJECT_NAME "example")
cmake_host_system_information(RESULT _site QUERY HOSTNAME)
set(CTEST_SITE ${_site})
set(CTEST_BUILD_NAME "${CMAKE_SYSTEM_NAME}-${CMAKE_HOST_SYSTEM_PROCESSOR}")

# 为源和构建目录指定路径:
set(CTEST_SOURCE_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}")
set(CTEST_BINARY_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}/build_ctest")
message(STATUS "CTEST_SOURCE_DIRECTORY = CTEST_SCRIPT_DIRECTORY: ${CTEST_SOURCE_DIRECTORY}")
message(STATUS "CTEST_BINARY_DIRECTORY = CTEST_SCRIPT_DIRECTORY/build_ctest: ${CTEST_BINARY_DIRECTORY}")

# 将计算出机器上可用的CPU芯数量，并将测试步骤的并行级设置为可用CPU芯数量，以使总测试时间最小化:
include(ProcessorCount)
ProcessorCount(N)
if(NOT N EQUAL 0)
  set(CTEST_BUILD_FLAGS -j${N})
  set(ctest_test_args ${ctest_test_args} PARALLEL_LEVEL ${N})
endif()

# 开始测试步骤并配置代码，将ENABLE_ASAN设置为ON:
# 使用Experimental模式
ctest_start(Experimental)

# 这个选项用于开启asan
# 这是在编译buggy库的时候用到的
# 这里有一个小问题, ENABLE_ASAN默认时关闭的，而且src中的buggy库是先于test构建的
# 那么在构建之后再test这个标志为什么还会其作用？

# 答案也许已经有了，测试时我们直接运行：
# ctest -S dashboard.cmake -DCTEST_CMAKE_GENERATOR="Unix Makefiles"
# 并没有先build, ctest命令内部应该会自动运行build，从上设置的
# set(CTEST_SOURCE_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}")
# set(CTEST_BINARY_DIRECTORY "${CTEST_SCRIPT_DIRECTORY}/build_ctest")
# 参数也可以推测，并且运行之后确实生成了build_ctest目录
ctest_configure(
  OPTIONS
    -DENABLE_ASAN:BOOL=ON
  )

# dashboard.cmake其他命令为映射到构建、测试、内存检查和提交步骤:
ctest_build()
ctest_test()

set(CTEST_MEMORYCHECK_TYPE "AddressSanitizer")
ctest_memcheck()

ctest_submit()
