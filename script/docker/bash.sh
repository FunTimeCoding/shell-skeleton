#!/bin/sh -e

# shellcheck source=/dev/null
. "${HOME}/.virtualization-tools.sh"
CONTAINER_IDENTIFIER="${1}"

if [ "${CONTAINER_IDENTIFIER}" = '' ]; then
    echo "Usage: ${0} CONTAINER_IDENTIFIER"
    # TODO 1: Search for "${PROJECT_NAME_DASH}-instance" and use if it exists
    # TODO 2: Filter output for "${PROJECT_NAME_DASH}" if not found
    docker ps -a

    exit 1
fi

docker commit "${CONTAINER_IDENTIFIER}" "${PROJECT_NAME_DASH}-bash"
docker run --interactive --tty --entrypoint bash --name "${PROJECT_NAME_DASH}-bash-instance" --volume "${PWD}/tmp:/go/src/app/tmp" "${PROJECT_NAME_DASH}-bash"
docker rm "${PROJECT_NAME_DASH}-bash-instance"
docker image rm "${PROJECT_NAME_DASH}-bash"
