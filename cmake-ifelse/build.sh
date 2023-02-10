#!/bin/bash

cmake -H. -Bbuild -D USE_LIBRARY=ON -D MAKE_STATIC_LIBRARY=ON -D CMAKE_CXX_COMPILER=clang++ -D CMAKE_BUILD_TYPE=Debug

cmake --build build --target clean

cmake --build build
