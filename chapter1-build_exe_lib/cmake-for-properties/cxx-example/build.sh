#!/bin/bash

cmake -H. -Bbuild
# VERBOSE检查构建步骤
cmake --build build -- VERBOSE=1
