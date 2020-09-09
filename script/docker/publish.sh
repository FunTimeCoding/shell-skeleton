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

docker tag "${PROJECT_NAME_DASH}-snapshot" "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
docker tag "${PROJECT_NAME_DASH}-snapshot" "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:latest"

docker push "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
docker push "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:latest"

# Clean up local Docker tags
docker rmi "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
docker rmi "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:latest"
