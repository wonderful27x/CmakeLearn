#!/bin/bash

ctest -S dashboard.cmake -DCTEST_CMAKE_GENERATOR="Unix Makefiles"

cmake -H. -Bbuild -DENABLE_ASAN=ON -DCMAKE_INSTALL_PREFIX=./build_install
cmake --build build
cmake --build build --target test
