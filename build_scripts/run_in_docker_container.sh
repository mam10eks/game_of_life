#!/bin/bash -e

PORT=8080

./build_scripts/install.sh

DOCKER_FILE="COPY index.html /usr/share/nginx/html/\n"
DOCKER_FILE="${DOCKER_FILE}COPY all.js /usr/share/nginx/html/\n"
DOCKER_FILE="${DOCKER_FILE}COPY *.css* /usr/share/nginx/html/\n"

if [ -n "$(cat /proc/cpuinfo|grep ARMS)" ]; then
	echo "Create docker file for arm cpu architecture"
	DOCKER_FILE="FROM tobi312/rpi-nginx:alpine\n${DOCKER_FILE}"
else
	echo "Create docker file for x86/x64 architecture"
	DOCKER_FILE="FROM nginx:1.13-alpine\n${DOCKER_FILE}"
fi

echo -e "${DOCKER_FILE}" > build/Dockerfile

docker build -t elm-game-of-life:latest build

docker run --rm -p ${PORT}:80 elm-game-of-life:latest
