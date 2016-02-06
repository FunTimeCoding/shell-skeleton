#!/bin/sh -e

TARGET_PROJECT="${1}"

if [ "${TARGET_PROJECT}" = "" ]; then
    echo "Usage: ${0} TARGET_PROJECT"

    exit 1
fi

if [ ! -d "${TARGET_PROJECT}" ]; then
    echo "Target directory ${TARGET_PROJECT} does not exist."

    exit 1
fi

CAMEL=$(head -n1 "${TARGET_PROJECT}"/README.md | awk '{ print $2 }' | grep -E '^([A-Z]+[a-z0-9]*){2,}$') || CAMEL=""

if [ "${CAMEL}" = "" ]; then
    echo "Could not determine the projects name in ${TARGET_PROJECT}."

    exit 1
fi

OPERATING_SYSTEM=$(uname)

if [ "${OPERATING_SYSTEM}" = "Linux" ]; then
    FIND="find"
    SED="sed"
else
    FIND="gfind"
    SED="gsed"
fi

cp ./*.md "${TARGET_PROJECT}"
cp ./*.sh "${TARGET_PROJECT}"
cp .gitignore "${TARGET_PROJECT}"
DASH=$(echo "${CAMEL}" | ${SED} -E 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
INITIALS=$(echo "${CAMEL}" | ${SED} 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | ${SED} -E 's/-/_/g')
cd "${TARGET_PROJECT}" || exit 1
rm init-project.sh sync-project.sh
# shellcheck disable=SC2016
${FIND} . -type f -regextype posix-extended ! -regex '^.*/(\.git|\.idea)/.*$' -exec sh -c '${1} -i -e "s/ShellSkeleton/${2}/g" -e "s/shell-skeleton/${3}/g" -e "s/shell_skeleton/${4}/g" -e "s/bin\/ss/bin\/${5}/g" "${6}"' '_' "${SED}" "${CAMEL}" "${DASH}" "${UNDERSCORE}" "${INITIALS}" '{}' \;
echo "Done. Files were copied to ${TARGET_PROJECT} and modified. Review those changes."
