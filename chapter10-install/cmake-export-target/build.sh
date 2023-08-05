#!/bin/bash

# config
cmake -H. -Bcmake_ign_build \
    -DCMAKE_INSTALL_PREFIX=./cmake_ign_install \
    -DCMAKE_BUILD_TYPE=Debug

# build and install
cmake --build cmake_ign_build --target install

# test
cmake --build cmake_ign_build --target test
