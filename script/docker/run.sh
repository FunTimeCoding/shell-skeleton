#!/bin/sh -e

docker ps --all | grep --quiet shell-skeleton && FOUND=true || FOUND=false

if [ "${FOUND}" = false ]; then
    # TODO: This is the production setup that copies the code into the container image. How to decide whether to mount it or copy the code into the container in the Dockerfile?
    #docker run --name shell-skeleton funtimecoding/shell-skeleton

    # TODO: This is the development setup that mounts the project root so it can be changed and re-ran without rebuilding. Should this stay as a run.sh argument?
    docker run --name shell-skeleton --volume $(pwd):/shell-skeleton funtimecoding/shell-skeleton

    # TODO: Specifying the entry point overrides CMD in Dockerfile. Is this useful, or should all sub commands go through one entry point script? I'm inclined to say one entry point script per project.
    #docker run --name shell-skeleton --volume $(pwd):/shell-skeleton --entrypoint /shell-skeleton/bin/other.sh funtimecoding/shell-skeleton
else
    docker start --attach shell-skeleton
fi
