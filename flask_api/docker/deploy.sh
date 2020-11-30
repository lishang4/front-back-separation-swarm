#!/bin/bash

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
source $DIR/common.sh

set +o noglob

stage=0

clear

h3 "[$(cat README.md)]"

workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $workdir

h2 "[Step $stage]: checking if docker is installed ..."; let stage+=1
check_docker

h2 "[Step $stage]: checking docker-compose is installed ..."; let stage+=1
check_dockercompose

h2 "[Step $stage]: loading web-api's image ..."; let stage+=1
if [ -f web-api_*.tar.xz ]
then
    note "Great! found web-api's image file ..."
    docker load -i ./web-api_*.tar.xz
else
    error "web-api's .tar.xz file missing or use a incorrect naming format."
    exit 1
fi
echo ""

h2 "[Step $stage]: preparing environment ...";  let stage+=1
note 'TAG='$(ls | grep web-api | grep .tar.xz | cut -c 13-19)
echo 'TAG='$(ls | grep web-api | grep .tar.xz | cut -c 13-19) > .env
echo ""

h2 "[Step $stage]: checking if container is running ...";  let stage+=1
if [ -n "$(docker-compose --compatibility ps -q)"  ]
then
    note "web-api is running, stopping existing te-webhook3 instance ..."
    docker-compose --compatibility down -v
fi
note "te-webhook3 is not running ..."
echo ""

h2 "[Step $stage]: starting web-api ...";  let stage+=1
docker-compose --compatibility up -d
if [ -n "$(docker ps | grep web-api | grep up)"]
then
    note "web-api has been installed."
else
    error "web-api up fail."
    exit 1
fi
echo ""

#h2 "[Step $stage]: testing web-api ...";  let stage+=1
#sleep 5
#docker exec -it web-api sh -c 'cd unitTest && sh ./test.sh'
#echo ""

echo $cmd
eval $cmd
success $"----web-api server started successfully.----"
