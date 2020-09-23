#!/bin/bash

set -x
set -e

SCRIPT_DIR=${SCRIPT_DIR:=.}
DOCKER_ORGANIZATION=${DOCKER_ORGANIZATION:=koyeb}

name=$(cat koyeb.yaml | yq r - functions[0].name)
runtime=$(cat koyeb.yaml | yq r - functions[0].runtime)
handler=$(cat koyeb.yaml | yq r - functions[0].handler)

mkdir -p $SCRIPT_DIR/out
mkdir -p $SCRIPT_DIR/.cache

docker run --rm -v $SCRIPT_DIR/build.sh:/build.sh -v $PWD:/koyeb/repo/git -v $SCRIPT_DIR/.cache:/var/buildpack/cache -e XDG_CACHE_HOME=/var/buildpack/cache -e KOYEB_OUTPUT_FILE=/koyeb/build/$name.tar -v $SCRIPT_DIR/out:/koyeb/build --entrypoint /build.sh koyeb/runtime:build-$runtime /koyeb/repo/git /var/buildpack/cache
docker build --build-arg HANDLER=$handler --build-arg RUNTIME=$runtime --build-arg PROJECT=$name -t $DOCKER_ORGANIZATION/$name $SCRIPT_DIR
