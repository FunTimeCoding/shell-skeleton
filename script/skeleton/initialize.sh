#!/bin/sh -e

CAMEL=$(echo "${1}" | grep -E '^([A-Z]+[a-z0-9]*){1,}$') || CAMEL=""

if [ "${CAMEL}" = "" ]; then
    echo "Usage: ${0} UpperCamelCaseName"

    exit 1
fi

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    SED="gsed"
    FIND="gfind"
else
    SED="sed"
    FIND="find"
fi

rm -rf script/skeleton
DASH=$(echo "${CAMEL}" | ${SED} -E 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
INITIALS=$(echo "${CAMEL}" | ${SED} 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | ${SED} -E 's/-/_/g')
# shellcheck disable=SC2016
${FIND} . -type f -regextype posix-extended ! -regex '^.*/(\.git|\.idea)/.*$' -exec sh -c '${1} -i -e "s/ShellSkeleton/${2}/g" -e "s/shell-skeleton/${3}/g" -e "s/shell_skeleton/${4}/g" -e "s/bin\/ss/bin\/${5}/g" "${6}"' '_' "${SED}" "${CAMEL}" "${DASH}" "${UNDERSCORE}" "${INITIALS}" '{}' \;
git mv lib/shell_skeleton.sh lib/"${UNDERSCORE}".sh
git mv bin/ss bin/"${INITIALS}"
