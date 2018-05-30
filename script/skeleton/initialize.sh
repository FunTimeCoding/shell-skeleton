#!/bin/sh -e

NAME=$(echo "${1}" | grep --extended-regexp '^([A-Z]+[a-z0-9]*){1,}$') || NAME=''

if [ "${NAME}" = '' ]; then
    echo "Usage: ${0} NAME"
    echo "Name must be in upper camel case."

    exit 1
fi

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    SED='gsed'
    FIND='gfind'
else
    SED='sed'
    FIND='find'
fi

rm -rf script/skeleton
DASH=$(echo "${NAME}" | ${SED} --regexp-extended 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
INITIALS=$(echo "${NAME}" | ${SED} 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | ${SED} --regexp-extended 's/-/_/g')
# shellcheck disable=SC2016
# TODO: This does not update the initials in Vagrantfile yet.
${FIND} . -type f -regextype posix-extended ! -regex '^.*/(\.git|\.idea)/.*$' -exec sh -c '${1} -i --expression "s/ShellSkeleton/${2}/g" --expression "s/shell-skeleton/${3}/g" --expression "s/shell_skeleton/${4}/g" --expression "s/bin\/ss/bin\/${5}/g" --expression "s/ss\\\\/${5}\\\\/g" "${6}"' '_' "${SED}" "${NAME}" "${DASH}" "${UNDERSCORE}" "${INITIALS}" '{}' \;
git mv lib/shell_skeleton.sh "lib/${UNDERSCORE}.sh"
git mv bin/ss "bin/${INITIALS}"
echo "# This dictionary file is for domain language." > "documentation/dictionary/${DASH}.dic"
