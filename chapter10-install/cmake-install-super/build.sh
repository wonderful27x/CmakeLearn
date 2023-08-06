#!/bin/bash

cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=./build_install

cmake --build build

cmake --build build --target install

cmake --build build --target test

# package 打包二进制和源文件
cmake --build build --target package_source package
