#!/bin/sh -e

# Development mode mounts the project root so it can be edited and re-ran without rebuilding the image and recreating the container.

if [ "${1}" = --development ]; then
    DEVELOPMENT=true
else
    DEVELOPMENT=false
fi

docker ps --all | grep --quiet shell-skeleton && FOUND=true || FOUND=false

if [ "${FOUND}" = false ]; then
    if [ "${DEVELOPMENT}" = true ]; then
        docker create --name shell-skeleton --volume $(pwd):/shell-skeleton funtimecoding/shell-skeleton
    else
        docker create --name shell-skeleton funtimecoding/shell-skeleton
    fi

    # TODO: Specifying the entry point overrides CMD in Dockerfile. Is this useful, or should all sub commands go through one entry point script? I'm inclined to say one entry point script per project.
    #docker create --name shell-skeleton --volume $(pwd):/shell-skeleton --entrypoint /shell-skeleton/bin/other.sh funtimecoding/shell-skeleton
    #docker create --name shell-skeleton funtimecoding/shell-skeleton /shell-skeleton/bin/other.sh
    # TODO: Run tests this way?
    #docker create --name shell-skeleton funtimecoding/shell-skeleton /shell-skeleton/script/docker/test.sh
fi

docker start --attach shell-skeleton
