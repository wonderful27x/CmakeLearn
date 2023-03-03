#!/bin/bash

# config
cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=./build_install

# build and install
cmake --build build --target install

# test
cmake --build build --target test
