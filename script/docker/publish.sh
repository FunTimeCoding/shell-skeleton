#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../configuration/project.sh"
# shellcheck source=/dev/null
. "${HOME}/.virtualization-tools.sh"
GIT_TAG="${1}"

if [ "${GIT_TAG}" = '' ]; then
    echo "Usage: ${0} GIT_TAG"

    exit 1
fi

git config --get remote.origin.url | grep --quiet github.com && IS_GITHUB=true || IS_GITHUB=false

if [ "${IS_GITHUB}" = 'true' ]; then
    REGISTRY_SERVER='ghcr.io'
else
    REGISTRY_SERVER="${PRIVATE_REGISTRY_PASSWORD}"
fi

docker tag "${PROJECT_NAME_DASH}-snapshot" "${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
docker tag "${PROJECT_NAME_DASH}-snapshot" "${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:latest"

docker push "${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
docker push "${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:latest"

# Clean up local tags
docker rmi "${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
docker rmi "${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:latest"
