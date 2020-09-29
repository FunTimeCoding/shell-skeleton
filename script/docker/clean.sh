#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../configuration/project.sh"

INSTANCES=$(docker ps --all | grep "${PROJECT_NAME_DASH}" | awk '{ print $1 }')

for INSTANCE in ${INSTANCES}; do
    docker rm "${INSTANCE}"
done

IMAGES=$(docker images | grep "${PROJECT_NAME_DASH}" | awk '{ print $1 }')

for IMAGE in ${IMAGES}; do
    docker rmi "${IMAGE}"
done
