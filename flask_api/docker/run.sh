#!/bin/bash
# NOTE:
# DO NOT touch anything outside <EDIT_ME></EDIT_ME>,
# unless you really know what you are doing.
REPO=harbor.lishang4.com/fju
# The name of the container, should use the name of the repo is possible
# <EDIT_ME>
CONTAINER=web-api
# </EDIT_ME>

# Get tags from args
TAG=$2
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG
echo "# Launching $DOCKER_IMAGE"
# Check if docker image exists (locally or on the registry)
local_img=$(docker images | grep $REPO | grep $CONTAINER | grep $TAG)
if [ -z "$local_img" ] ; then
  echo "# Image not found locally, let's try to pull it from the registry."
  docker pull $DOCKER_IMAGE
  if [ "$?" -ne 0 ]; then
    echo "# Error: Image not found: $DOCKER_IMAGE"
    exit 1
  fi
fi
echo "# Great! Docker image found: $DOCKER_IMAGE"

# Load env file
source $1
if [ "$?" -ne 0 ]; then
  echo "Erorr, can't open envfile: $1"
  echo "Usage: $0 <env file> <docker image tag>"
  echo "e.g., "
  echo " $0 dev.env 94crazy"
  exit 1
else
  envfile=$1
  echo "# Using envfile: $envfile"
fi

# global config:
# - use local timezone
# - max memory = 256m
# - restart = always
globalConf="
  -v /etc/localtime:/etc/localtime \
  -m 256m \
  --restart always \
  --net single \
"

# <EDIT_ME>
moduleConf="
  -p $TW_PORT:$TW_PORT \
  --env-file $envfile \
"
# </EDIT_ME>

docker rm -f -v $CONTAINER
cmd="docker run -d --name $CONTAINER \
  $globalConf \
  $moduleConf \
  $DOCKER_IMAGE \
"
echo $cmd
eval $cmd

# </EDIT_ME>
