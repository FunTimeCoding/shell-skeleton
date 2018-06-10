#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/skeleton/skeleton.sh"

if [ "${1}" = --help ]; then
    echo "Usage: ${0} [--ci-mode]"

    exit 0
fi

CONCERN_FOUND=false
CONTINUOUS_INTEGRATION_MODE=false

if [ "${1}" = --ci-mode ]; then
    shift
    mkdir -p build/log
    CONTINUOUS_INTEGRATION_MODE=true
fi

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    FIND='gfind'
else
    FIND='find'
fi

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    FILES=$(${FIND} . -regextype posix-extended -name '*.sh' ! -regex "${EXCLUDE_FILTER}" -printf '%P\n')

    for FILE in ${FILES}; do
        FILE_REPLACED=$(echo "${FILE}" | sed 's/\//-/g')
        shellcheck --format checkstyle "${FILE}" > "build/log/checkstyle-${FILE_REPLACED}.xml" || true
    done
else
    # shellcheck disable=SC2016
    SHELL_SCRIPT_CONCERNS=$(${FIND} . -name '*.sh' -regextype posix-extended ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'shellcheck ${1} || true' '_' '{}' \;)

    if [ ! "${SHELL_SCRIPT_CONCERNS}" = '' ]; then
        CONCERN_FOUND=true
        echo "(WARNING) Shell script concerns:"
        echo "${SHELL_SCRIPT_CONCERNS}"
    fi
fi

# shellcheck disable=SC2016
EMPTY_FILES=$(${FIND} . -regextype posix-extended -type f -empty ! -regex "${EXCLUDE_FILTER}")

if [ ! "${EMPTY_FILES}" = '' ]; then
    CONCERN_FOUND=true

    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
        echo "${EMPTY_FILES}" > build/log/empty-files.txt
    else
        echo
        echo "(WARNING) Empty files:"
        echo
        echo "${EMPTY_FILES}"
    fi
fi

# shellcheck disable=SC2016
TO_DOS=$(${FIND} . -regextype posix-extended -type f ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'grep -Hrn TODO "${1}" | grep -v "${2}"' '_' '{}' '${0}' \;)

if [ ! "${TO_DOS}" = '' ]; then
    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
        echo "${TO_DOS}" > build/log/to-dos.txt
    else
        echo
        echo "(NOTICE) To dos:"
        echo
        echo "${TO_DOS}"
    fi
fi

# shellcheck disable=SC2016
SHELLCHECK_IGNORES=$(${FIND} . -regextype posix-extended -type f ! -regex "${EXCLUDE_FILTER}" -exec sh -c 'grep -Hrn "# shellcheck" "${1}" | grep -v "${2}"' '_' '{}' '${0}' \;)

if [ ! "${SHELLCHECK_IGNORES}" = '' ]; then
    if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
        echo "${SHELLCHECK_IGNORES}" > build/log/shellcheck-ignores.txt
    else
        echo
        echo "(NOTICE) Shellcheck ignores:"
        echo
        echo "${SHELLCHECK_IGNORES}"
    fi
fi

if [ "${CONCERN_FOUND}" = true ]; then
    if [ "${CONTINUOUS_INTEGRATION_MODE}" = false ]; then
        echo
        echo "Concern(s) of category WARNING found." >&2
    fi

    exit 2
fi
