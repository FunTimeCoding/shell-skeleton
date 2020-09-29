#!/bin/sh -e

# shellcheck source=/dev/null
. "${HOME}/.virtualization-tools.sh"

git config --get remote.origin.url | grep --quiet github.com && IS_GITHUB=true || IS_GITHUB=false

if [ "${IS_GITHUB}" = 'true' ]; then
    REGISTRY_SERVER='ghcr.io'
    REGISTRY_USERNAME="${PUBLIC_REGISTRY_USERNAME}"
    REGISTRY_PASSWORD="${PUBLIC_REGISTRY_TOKEN}"
else
    REGISTRY_SERVER="${PRIVATE_REGISTRY_SERVER}"
    REGISTRY_USERNAME="${PRIVATE_REGISTRY_USERNAME}"
    REGISTRY_PASSWORD="${PRIVATE_REGISTRY_PASSWORD}"
fi

echo "${REGISTRY_PASSWORD}" | docker login --username "${REGISTRY_USERNAME}" --password-stdin "${REGISTRY_SERVER}"
