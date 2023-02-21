#!/bin/bash

cmake -H. -Bbuild
cmake --build build
cd build
ctest -V
