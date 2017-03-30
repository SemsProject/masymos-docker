#!/bin/sh

# Build script for MaSyMoS
# based on the Makefile from Martin Peters
# https://github.com/FreakyBytes/bachelor-thesis/blob/master/source/Makefile

# compile/install masymos-core
(cd $SRC_DIR/masymos-core && mvn install) || exit 1

# compile masymos-cli
(cd $SRC_DIR/masymos-cli && mvn package) || exit 1

# compile morre
(cd $SRC_DIR/masymos-morre && mvn package) || exit 1

# compile/install masymos-diff
(cd $SRC_DIR/masymos-diff && mvn install) || exit 1

# compile masymos-diff-rest
(cd $SRC_DIR/masymos-diff-rest && mvn package) || exit 1
