#!/bin/bash

# test
cmake --build build --target test

# test
cd build
ctest -V
