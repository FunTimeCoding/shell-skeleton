#!/bin/sh -e

docker images | grep --quiet funtimecoding/shell-skeleton && FOUND=true || FOUND=false

if [ "${FOUND}" = true ]; then
    docker rmi funtimecoding/shell-skeleton
fi

docker build --tag funtimecoding/shell-skeleton .
