# set minimum cmake version
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

# project name and language
project(recipe-01 LANGUAGES CXX)

# require C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# process src/CMakeLists.txt
add_subdirectory(src)

enable_testing()

# allow to report to a cdash dashboard
# 引入Ctest以便向cdash报告测试结果
# CTest支持三种不同的提交模式：
# 实验性构建
# 夜间构建
# 持续构建
# 我们使用了ctest --dashboard Experimental(实验性构建提交)，因此，测试结果显示在实验模式之下。
# 我们也可用设置午夜模式
# 夜间开始时间可以设置为世界时的"午夜"：
# set(CTEST_NIGHTLY_START_TIME "00:00:00 UTC")
# 建、测试和提交到实验面板只需要一个命令— cmake --build . --target Experimental
# 也可以先build,在运行
# ctest --dashboard Experimental
include(CTest)

# process tests/CMakeLists.txt
add_subdirectory(tests)
