#!/bin/bash

# 构建
cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=./build_install

# 查询可用命令
cmake --build build --target help

# 打包二进制和源文件
cmake --build build --target package_source package

# 也可以直接进入build目录执行：
# cpack -G RPM
