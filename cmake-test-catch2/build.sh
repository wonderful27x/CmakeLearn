#!/bin/bash

cmake -H. -Bbuild
cmake --build build
cmake --build build --target test

cd build
ctest -V
