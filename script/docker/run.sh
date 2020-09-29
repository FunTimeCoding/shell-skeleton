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

if [ "${1}" = --help ]; then
    echo "Usage: ${0} --development|[GIT_TAG]"
    echo "Examples:"
    echo "In development: ${0} --development"
    echo "In production: ${0} 1.0.0"

    exit 0
fi

if [ "${1}" = --development ]; then
    DEVELOPMENT=true
    shift
else
    DEVELOPMENT=false
fi

if [ "${DEVELOPMENT}" = true ]; then
    IMAGE="${PROJECT_NAME_DASH}-snapshot"
else
    GIT_TAG="${1}"

    if [ "${GIT_TAG}" = '' ]; then
        GIT_TAG='latest'
        shift
    fi

    git config --get remote.origin.url | grep --quiet github.com && IS_GITHUB=true || IS_GITHUB=false

    if [ "${IS_GITHUB}" = 'true' ]; then
        REGISTRY_SERVER='ghcr.io'
    else
        REGISTRY_SERVER="${PRIVATE_REGISTRY_PASSWORD}"
    fi

    IMAGE="${REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
fi

SYSTEM=$(uname -o)

if [ "${SYSTEM}" = 'Msys' ]; then
    # TODO: Add volume parameters that work on Windows.
    # shellcheck disable=SC2068
    winpty docker run --interactive --tty --rm --name "${PROJECT_NAME_DASH}-instance" "${IMAGE}" ${@}
else
    # shellcheck disable=SC2068
    docker run --interactive --tty --rm --name "${PROJECT_NAME_DASH}-instance" "${IMAGE}" ${@}
fi
