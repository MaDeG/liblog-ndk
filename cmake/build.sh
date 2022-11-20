#!/bin/bash

mkdir -p cmake-build-debug
cd cmake-build-debug
conan install ../conanfile.txt --profile:build ../build.profile --profile:host ../armv8.profile
cmake .. -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake
make