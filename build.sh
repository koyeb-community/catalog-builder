#!/bin/bash

set -x

BUILD_DIR=$1
CACHE_DIR=$2

/var/buildpack/bin/compile $BUILD_DIR $CACHE_DIR
/var/buildpack/bin/release $BUILD_DIR $KOYEB_OUTPUT_FILE
