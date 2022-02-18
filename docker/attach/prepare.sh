#!/usr/bin/env bash
# 환경변수 불러오기
source /mnt/conf/docker.conf

if [ ! -d /mount/logs/$appId ]; then
    mkdir -p /mount/logs/$appId
fi

# NOTE: /docker-entrypoint.sh 내부에서 mysqld를 mysql 계정으로 실행하도록 되어 있어
# root 소유인 로그 폴더에 로그를 쓰기 가능하도록 하기 위한 조치
chmod 775 -R /mount/logs/$appId

groupmod -g 0 -o $(id -g -n mysql)
chown -R mysql:mysql /mount/lib/$appId

# run mysqld
exec docker-entrypoint.sh mysqld $LOG_OPT \
    >> /mount/logs/$appId/attach.log 2>&1
