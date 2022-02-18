#!/usr/bin/env bash

# appId는 자동으로 넣어짐.
basePath=$(dirname $0)/..
cd $basePath
basePath=$(pwd)
propertyPath=$(pwd)/conf/$appId

# 각각 docker run하는 것은 프로젝트 별로 달라질 수 있다.
function fnRunDocker() {
    # 주의: MYSQL_ROOT_PASSWORD는 첫시작시에 세팅됨. 후 grant 사용.
    MYSQL_ROOT_PASSWORD=${network["meta.datasource.pass"]}

    if [ -z "$DOCKER_PORT" ]; then
        echo "[ERROR] There is no config for meta port."
        exit 1
    fi

    # NOTE: 의도는 다르지만, /var/lib/mysql가 원위치이므로 아래로 지정
    echo "[INFO] $port <- $DOCKER_PORT"

    docker run \
        -p $DOCKER_PORT:3306 \
        -v $basePath/logs/$appId:/var/log/mysql \
        -v $basePath/lib/$appId:/var/lib/mysql \
        -v $basePath/conf/$appId/mariadb/mariadb.cnf:/etc/mysql/mariadb.cnf \
        -v $basePath/conf/$appId/docker-entrypoint-initdb.d:/docker-entrypoint-initdb.d \
        -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
        -e TZ=Asia/Seoul \
        -itd --name $instanceId $IMAGE_NAME:$version
}

if [ ! -f $basePath/common/bin/bin.sh ]; then
    echo "[ERROR] $basePath/common/bin/bin.sh is not found."
    exit 1
fi

# input: appId, company, basePath
source $basePath/common/bin/bin.sh
