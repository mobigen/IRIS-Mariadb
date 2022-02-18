#!/usr/bin/env bash

basePath=$(dirname $0)/..
cd $basePath
basePath=$(pwd)

# 실직적으로 다른 곳이 많기 때문에 빼냄.
dockerPath=$basePath/docker

# config 정보 불러오기
source $dockerPath/docker-conf/docker.conf

TARGET_HOME=$basePath/build/$servicePathName

# fileName이 다를 수도 있음.
fileName=$appId

# current date YYYYMMdd
today=$(date +%Y%m%d)

# git fetch --all --tags
newVersion=$(git describe --tags --abbrev=0 2> /dev/null)
originNewVersion=$(git describe --tags --abbrev=0 2> /dev/null)
# version tag가 없을 수도 있음.
if [ -z "$newVersion" ]; then
    newVersion=no_version
fi

headHash=$(git rev-parse --short=7 HEAD)
tagHash=$(git describe --tags --abbrev=6 | tail -c 7)
if [ "$headHash" != "$tagHash" ]; then
    echo "[INFO] git HEAD has a different tag. it will be added for you."
    newVersion=${newVersion}_${headHash}
fi

containerId=`docker ps -a | grep "[[:space:]]$instanceId$" | awk '{print $1}'`
for c in $containerId
do
    docker stop $c 2> /dev/null
    docker rm $c 2> /dev/null
done

# Directories
if [[ -d $TARGET_HOME ]]; then
    rm -rf $TARGET_HOME
fi
mkdir -p $TARGET_HOME
mkdir -p $TARGET_HOME/conf-template/$appId
mkdir -p $TARGET_HOME/lib/$appId
mkdir -p $TARGET_HOME/bin
mkdir -p $TARGET_HOME/install
mkdir -p $TARGET_HOME/images
mkdir -p $TARGET_HOME/common

# Download thirdparty
# $basePath/download-thirdparty.sh

# if [ $? != 0 ]; then
#     echo '[FAIL] docker build stopped because of third party download fail.'
#     exit 1;
# fi

echo '[INFO] Start to copy files.'
if [[ -d $dockerPath/conf ]]; then
    cp -ap $dockerPath/conf/* $TARGET_HOME/conf-template/$appId/
fi
cp -ap $dockerPath/docker-conf/docker.conf $TARGET_HOME/conf-template/$appId/

# property 파일 복사는 prod에서 함.(만약 local이라면 그게 맞게 처리 필요.)
# 압축을 푸는 것이기 때문에 체크를 하려면 생성 후 카피가 필요함.
# property path는 project별로 다를 수 있음.
# propertyPath=src/main/resources-prod/
# if [[ -d $basePath/$propertyPath ]]; then
#     cp -ap $basePath/$propertyPath/* $TARGET_HOME/conf-template/$appId
# fi

# cp -ap $basePath/lib/* $TARGET_HOME/lib/$appId/
# if [ $? != 0 ]; then
#     echo '[FAIL] lib directory is empty. you need to download lib files first.'
#     exit 1;
# fi

cp $dockerPath/bin/bin.sh $TARGET_HOME/bin/$appId.sh
cp $dockerPath/install/install.sh $TARGET_HOME/install/$appId.sh
if [[ -f $dockerPath/bin/setup-apply.sh ]]; then
    cp $dockerPath/bin/setup-apply.sh $TARGET_HOME/bin/$appId-setup-apply.sh
fi

function fnSet() {
    line=$1
    string=$2
    confFile=$3
    # WARN: BSD sed, GNU sed의 차이에 의해서 아래처럼 사용함.
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e $line' i\
'$string'
' $confFile
else
        sed -i'' -e $line' i\
'$string'
' $confFile
fi
}
fnSet 3 appId=$appId $TARGET_HOME/bin/$appId.sh
fnSet 4 instanceId=$instanceId $TARGET_HOME/bin/$appId.sh
fnSet 5 company=$company $TARGET_HOME/bin/$appId.sh
fnSet 3 appId=$appId $TARGET_HOME/install/$appId.sh
fnSet 4 instanceId=$instanceId $TARGET_HOME/install/$appId.sh
fnSet 5 company=$company $TARGET_HOME/install/$appId.sh

echo '[INFO] finished to copy files.'

echo "========================================================="
echo "## Docker Build Start"
echo "========================================================="
docker build \
    --build-arg appId=$appId \
    -t $IMAGE_NAME:$newVersion \
    $basePath
docker tag \
    $IMAGE_NAME:$newVersion repo.iris.tools/iris/$IMAGE_NAME:${originNewVersion}-RC$(date +%Y%m%d).0-${headHash}

echo "========================================================="
echo "repo.iris.tools/iris/$IMAGE_NAME:${originNewVersion}-RC$(date +%Y%m%d).0-${headHash}"
echo "========================================================="

if [ $? != 0 ]; then
    echo "[ERROR] docker build failed."
    exit 1
fi

docker save -o $TARGET_HOME/images/$appId.tar.gz $IMAGE_NAME:$newVersion
if [ $? != 0 ]; then
    echo "[ERROR] docker save failed."
    exit 1
fi

# Tar all the results
cd $TARGET_HOME/..
tar cvzf $appId-dist-$newVersion-$today.tar.gz $servicePathName
rm -rf $TARGET_HOME
echo "========================================================="
echo "## Docker Build End - $IMAGE_NAME:$newVersion"
echo "========================================================="
