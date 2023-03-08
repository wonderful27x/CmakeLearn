#!/bin/bash

cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=./build_install -DENABLE_NETBEANS=OFF -DENABLE_CHANNEL=ON -DENABLE_TERMINAL=ON
cmake --build build
cmake --build --target test
