#!/bin/sh -e

docker ps --all | grep --quiet shell-skeleton && FOUND=true || FOUND=false

if [ "${FOUND}" = false ]; then
    # TODO: Provide container with copy of code and one mounting the code?
    # Copy of code should be for production use so repository is not required anymore.
    # Mounting the code should be for development so changes can be made quick and tested without rebuilding the container.
    #docker run --name shell-skeleton funtimecoding/shell-skeleton
    docker run --name shell-skeleton --volume $(pwd):/shell-skeleton funtimecoding/shell-skeleton
fi

docker start --attach shell-skeleton
