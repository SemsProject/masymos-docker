#!/bin/bash

# check if docker is ok
docker info &> /dev/null || (echo "Please install docker and ensure it's running and operational" && exit 1)

# build the build-env image
docker build -f Dockerfile.build-env -t masymos-build-env:latest .

# run the build
docker run --rm -t -v $(pwd)/src/:/root/src/ -e "SRC_DIR=/root/src"  masymos-build-env:latest

# build the actual masymos container
#docker build -f Dockerfile -t freakybytes/masymos:latest .


