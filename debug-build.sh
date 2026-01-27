#!/bin/sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=DEBUG && cmake --build build -j 16
