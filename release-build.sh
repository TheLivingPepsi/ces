#!/bin/sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS_RELEASE="-ffast-math" && cmake --build build -j 16
