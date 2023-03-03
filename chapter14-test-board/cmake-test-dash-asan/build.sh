#!/bin/bash

# 测试发现直接运行这个命令也可以，难度内部自动进行构建了？
# 这个命令内部会进行构建，dashboard.cmake中设置了build_ctest目录，
# 与外部生成的build_ctest目录一致，可以认为已经执行cmake -H. -Bbuild_ctest
# 而ENABLE_ASAN这个选项在dashboard.cmake中设置为ON
ctest -S dashboard.cmake -DCTEST_CMAKE_GENERATOR="Unix Makefiles"

# 在本地运行测试，并启用asan
cmake -H. -Bbuild -DENABLE_ASAN=ON -DCMAKE_INSTALL_PREFIX=./build_install
cmake --build build
cmake --build build --target test
