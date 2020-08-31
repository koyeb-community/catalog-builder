#!/bin/bash

set -x
set -e

SCRIPT_DIR=${SCRIPT_DIR:=.}
DOCKER_ORGANIZATION=${DOCKER_ORGANIZATION:=koyeb}
TAGS=""
NAME=$(cat koyeb.yaml | yq r - functions[0].name)

if [[ "$GITHUB_REF" =~ ^refs/tags/v.*$ ]]; then
  release=${GITHUB_REF#refs/*/}
  major=$(echo $release | awk -F \. {'print $1'})
  minor=$(echo $release | awk -F \. {'print $1 "." $2'})
  TAGS="$release"
  TAGS+=" $major"
  TAGS+=" $minor"
fi

IMAGE=$DOCKER_ORGANIZATION/$NAME

# Push image and tags
docker push $IMAGE
for tag in $TAGS ;
do
  docker tag $IMAGE $IMAGE:$tag
  docker push $IMAGE:$tag
done

# Update docker desc with readme
# Not working with access token, see https://github.com/docker/hub-feedback/issues/1927
#docker run -v ${PWD}:/workspace \
#  -e DOCKERHUB_USERNAME='$DOCKER_USERNAME' \
#  -e DOCKERHUB_PASSWORD='$DOCKER_PASSWORD' \
#  -e DOCKERHUB_REPOSITORY='$IMAGE' \
#  -e README_FILEPATH='/workspace/README.md' \
#  peterevans/dockerhub-description:2.3
