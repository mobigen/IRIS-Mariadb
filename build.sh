#!/bin/bash
cd $(dirname "$0")
scriptDir=$(pwd)

# clean build folder.
rm -rf $scriptDir/build/*

# default option: docker
if [[ "$1" =~ ^docker$ ]] ||  [ $# -eq 0 ]; then
    ./docker/docker-build.sh
else
    echo "No option is available - $1"
fi
