#!/bin/bash


usage() {
  echo "./build-image.sh [OPTIONS]"
  echo "    -v version         빌드 버전 (default: v2.9.0)"
  echo "    -r                 RC 버전을 빌드 (default: false)"
  echo "    -o order           RC 버전을 빌드 할 때 오늘 몇 번째 빌드인지 정수(int) 입력 (default: 0)"
  echo "                       default: k8s (k8s|docker)"
  exit 0
}

if [ $# -eq 0 ];
then
    usage
    exit 0
fi

rc=false
order=0

while getopts "v:ro:" opt
do
  case $opt in
    v) version=$OPTARG ;;
    r) rc=true ;;
    o) order=$OPTARG ;;
    h) usage ;;
    ?) usage ;;
  esac
done


# Build docker image with name option provided by user
today=$(date +%Y%m%d)
headHash=$(git rev-parse --short=7 HEAD)
if $rc;
then
  imgTag=${version}-RC${today}.${order}-${headHash}
else
  imgTag=${version}-${headHash}
fi

imgName=repo.iris.tools/iris/mariadb



echo "========================================================="
echo "## Image Build Start"
echo "========================================================="


docker build \
    -f Dockerfile \
    -t $imgName:$imgTag \
    .

echo "========================================================="
echo "## Image Build End - $imgName:$imgTag"
echo "========================================================="
