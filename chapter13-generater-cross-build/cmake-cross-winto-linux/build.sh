#!/bin/bash

# 交叉编译
# 通过将CMAKE_TOOLCHAIN_FILE指向工具链文件，从而配置代码(本例中，使用了从源代码构建的MXE编译器):
cmake -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DCMAKE_INSTALL_PREFIX=./build_install

cmake --build build
