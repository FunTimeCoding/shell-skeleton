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

# TODO: Keep development mode?
#if [ "${1}" = --development ]; then
#    DEVELOPMENT=true
#    shift
#else
#    DEVELOPMENT=false
#fi

GIT_TAG="${1}"

if [ "${GIT_TAG}" = '' ]; then
    GIT_TAG='latest'
fi

SYSTEM=$(uname)

# TODO: What is the output of uname on Git Bash on Windows 10?
if [ "${SYSTEM}" = 'msys' ]; then
    # TODO: Add volume parameters that work on Windows.
    winpty docker run --interactive --tty --rm --name "${PROJECT_NAME_DASH}-snapshot" --publish 8080:8080 "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
else
    # TODO: Make it possible to pass arguments to the container?
    #if [ "${DEVELOPMENT}" = true ]; then
    #    WORKING_DIRECTORY=$(pwd)
    #    # shellcheck disable=SC2068
    #    docker run --interactive --tty --rm --name "${PROJECT_NAME_DASH}" --volume "${WORKING_DIRECTORY}:/${PROJECT_NAME_DASH}" "${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}" $@
    #else
    #    # shellcheck disable=SC2068
    #    docker run --interactive --tty --rm --name "${PROJECT_NAME_DASH}" "${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}" $@
    #fi

    # TODO: Always publish port 8080, make configurable or remove?
    docker run --interactive --tty --rm --name "${PROJECT_NAME_DASH}-instance" --publish 8080:8080 --volume "${PWD}/tmp:/go/src/app/tmp" "${PRIVATE_REGISTRY_SERVER}/${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}:${GIT_TAG}"
fi
