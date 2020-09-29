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

git config --get remote.origin.url | grep --quiet github.com && IS_GITHUB=true || IS_GITHUB=false

if [ "${IS_GITHUB}" = 'true' ]; then
    REGISTRY_SERVER='ghcr.io'
else
    REGISTRY_SERVER="${PRIVATE_REGISTRY_PASSWORD}"
fi

helm delete --set "ImagePrefix=${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}" "${PROJECT_NAME_DASH}"
