#!/bin/bash

# 定义全局的宏，对所有项目有效
cmake -D CMAKE_CXX_FLAGS="-fno-exceptions -fno-rtti" -H. -Bbuild

cmake --build build -- VERBOSE=1
