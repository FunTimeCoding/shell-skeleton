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
helm status --set "ImagePrefix=${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}" "${PROJECT_NAME_DASH}"
