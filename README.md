# How-to

## Build Image

```bash
$ ./build.sh
./build.sh [OPTIONS]
    -v version         빌드 버전 (default: v2.9.0)
    -r                 RC 버전을 빌드 (default: false)
    -o order           RC 버전을 빌드 할 때 오늘 몇 번째 빌드인지 정수(int) 입력 (default: 0)
    
# Image tag를 입력해서 빌드를 한다.

$ ./build.sh -v v2.1.0
```

## Run

```bash

# 빌디 해서 만든 이미지를 다은과 같이 실행한다.

$ docker run --rm -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=test --name mariadb repo.iris.tools/iris/mariadb:{image_tag}
```