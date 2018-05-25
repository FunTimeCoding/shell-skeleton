#!/bin/sh -e

TARGET="${1}"

if [ "${TARGET}" = '' ]; then
    echo "Usage: ${0} TARGET"

    exit 1
fi

if [ ! -d "${TARGET}" ]; then
    echo "Target directory does not exist."

    exit 1
fi

NAME=$(head -n 1 "${TARGET}/README.md" | awk '{ print $2 }' | grep --extended-regexp '^([A-Z]+[a-z0-9]*){1,}$') || NAME=''

if [ "${NAME}" = '' ]; then
    echo "Could not determine the project name."

    exit 1
fi

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    FIND='gfind'
    SED='gsed'
else
    FIND='find'
    SED='sed'
fi

cp ./*.md "${TARGET}"
mkdir -p "${TARGET}/documentation"
cp -R documentation/* "${TARGET}/documentation"
mkdir -p "${TARGET}/script"
cp -R script/* "${TARGET}/script"
cp .gitignore "${TARGET}"
cp Vagrantfile "${TARGET}"
cd "${TARGET}" || exit 1
rm -rf script/skeleton
DASH=$(echo "${NAME}" | ${SED} --regexp-extended 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
INITIALS=$(echo "${NAME}" | ${SED} 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | ${SED} --regexp-extended 's/-/_/g')
# shellcheck disable=SC2016
# TODO: This does not update the initials in Vagrantfile yet.
${FIND} . -type f -regextype posix-extended ! -regex '^.*/(build|\.git|\.idea)/.*$' -exec sh -c '${1} -i --expression "s/ShellSkeleton/${2}/g" --expression "s/shell-skeleton/${3}/g" --expression "s/shell_skeleton/${4}/g" --expression "s/bin\/ss/bin\/${5}/g" --expression "s/ss\\/${5}\\/g" "${6}"' '_' "${SED}" "${NAME}" "${DASH}" "${UNDERSCORE}" "${INITIALS}" '{}' \;
