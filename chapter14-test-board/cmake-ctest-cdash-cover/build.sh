#!/bin/bash

cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=./build_install

cmake --build build --target Experimental
