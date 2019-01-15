#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../lib/project.sh"
SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    WC='gwc'
    FIND='gfind'
else
    WC='wc'
    FIND='find'
fi

FILES_EXCLUDE='^.*\/(build|tmp|vendor|\.git|\.vagrant|\.idea)\/.*$'
FILES=$(${FIND} . -type f -regextype posix-extended ! -regex "${FILES_EXCLUDE}" | ${WC} --lines)
DIRECTORIES_EXCLUDE='^.*\/(build|tmp|vendor|\.git|\.vagrant|\.idea)(\/.*)?$'
DIRECTORIES=$(${FIND} . -type d -regextype posix-extended ! -regex "${DIRECTORIES_EXCLUDE}" | ${WC} --lines)
INCLUDE='^.*\.sh$'
CODE_EXCLUDE='^.*\/(build|tmp|vendor|\.git|\.vagrant|\.idea)\/.*$'
CODE=$(${FIND} . -type f -regextype posix-extended -regex "${INCLUDE}" -and ! -regex "${CODE_EXCLUDE}" | xargs cat)
LINES=$(echo "${CODE}" | ${WC} --lines)
NON_BLANK_LINES=$(echo "${CODE}" | grep --invert-match --regexp '^$' | ${WC} --lines)
echo "FILES: ${FILES}"
echo "DIRECTORIES: ${DIRECTORIES}"
echo "LINES: ${LINES}"
echo "NON_BLANK_LINES: ${NON_BLANK_LINES}"

if [ "${1}" = --ci-mode ]; then
    shift

    if [ "${SYSTEM}" = Darwin ]; then
        TEE='gtee'
    else
        TEE='tee'
    fi

    mkdir -p build/log

    if [ -f "${HOME}/.sonar-qube-tools.sh" ]; then
        # shellcheck source=/dev/null
        . "${HOME}/.sonar-qube-tools.sh"
        sonar-scanner "-Dsonar.projectKey=${PROJECT_NAME}" -Dsonar.sources=. "-Dsonar.host.url=${SONAR_SERVER}" "-Dsonar.login=${SONAR_LOGIN}" | "${TEE}" build/log/sonar-runner.log
    else
        echo "SonarQube configuration missing."

        exit 1
    fi
fi
