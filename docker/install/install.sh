#!/usr/bin/env bash

# appId, company는 자동으로 넣어짐.
basePath=$(dirname $0)/..
cd $basePath
basePath=$(pwd)

if [ ! -f $basePath/common/install/install.sh ]; then
    echo "[ERROR] $basePath/common/install/install.sh is not found."
    exit 1
fi

# input: appId, company, basePath
source $basePath/common/install/install.sh
