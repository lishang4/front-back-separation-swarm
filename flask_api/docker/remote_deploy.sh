!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
source $DIR/common.sh

set +o noglob

REPO=harbor.lishang4.com/fju
CONTAINER=web-ui

GIT_HEAD="$(git rev-parse --short=8 HEAD)"
GIT_DATE=$(git log HEAD -n1 --pretty='format:%cd' --date=format:'%Y%m%d-%H%M')

TAG="${GIT_HEAD}-${GIT_DATE}"
DOCKER_IMAGE=$REPO/$CONTAINER:$TAG

stage=0

workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $workdir

h2 "[Step $stage]: checking if docker is installed ..."; let stage+=1
check_docker

h2 "[Step $stage]: checking docker-compose is installed ..."; let stage+=1
check_dockercompose

h2 "[Step $stage]: starting docker build  ..."; let stage+=1
./build.sh
echo ""

sleep 5

h2 "[Step $stage]: starting web-api & unittest   ..."
./run.sh dev.env ${TAG}

success $"----te-webhook3 started successfully.----"
