#!/bin/bash

set -x
set -e

NAME=$1
SCRIPT_DIR=${SCRIPT_DIR:=.}

name=$(cat koyeb.yaml | yq r - functions[0].name)
runtime=$(cat koyeb.yaml | yq r - functions[0].runtime)
handler=$(cat koyeb.yaml | yq r - functions[0].handler)

mkdir -p $SCRIPT_DIR/out
mkdir -p $SCRIPT_DIR/.cache

docker run --rm -v $SCRIPT_DIR/build.sh:/build.sh -v $PWD:/koyeb/repo/git -v $SCRIPT_DIR/.cache:/var/buildpack/cache -e XDG_CACHE_HOME=/var/buildpack/cache -e KOYEB_OUTPUT_FILE=/koyeb/build/$NAME.tar -v $SCRIPT_DIR/out:/koyeb/build koyeb/runtime:build-$runtime /build.sh /koyeb/repo/git /var/buildpack/cache
docker build --build-arg HANDLER=$handler --build-arg RUNTIME=$runtime --build-arg PROJECT=$NAME -t koyeb/$NAME $SCRIPT_DIR
