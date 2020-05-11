#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../configuration/project.sh"
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
mkdir -p "${TARGET}/debian"
cp -R debian/* "${TARGET}/debian"
mkdir -p "${TARGET}/configuration"
cp -R configuration/* "${TARGET}/configuration"
mkdir -p "${TARGET}/inventory"
cp -R inventory/* "${TARGET}/inventory"
cp .gitignore "${TARGET}"
cp playbook.yaml "${TARGET}"
cp Vagrantfile "${TARGET}"
cp Dockerfile "${TARGET}"
cp Jenkinsfile "${TARGET}"
cp sonar-project.properties "${TARGET}"
cd "${TARGET}" || exit 1
echo "${NAME}" | grep --quiet 'Skeleton$' && IS_SKELETON=true || IS_SKELETON=false

if [ "${IS_SKELETON}" = false ]; then
    rm -rf script/skeleton
fi

DASH=$(echo "${NAME}" | ${SED} --regexp-extended 's/([A-Za-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')
INITIALS=$(echo "${NAME}" | ${SED} 's/\([A-Z]\)[a-z]*/\1/g' | tr '[:upper:]' '[:lower:]')
UNDERSCORE=$(echo "${DASH}" | ${SED} --regexp-extended 's/-/_/g')
# shellcheck disable=SC2016
# TODO: Delete after testing the include way works throughout all projects.
#${FIND} . -regextype posix-extended -type f ! -regex "${EXCLUDE_FILTER}" -exec sh -c '${1} --in-place --expression "s/ShellSkeleton/${2}/g" --expression "s/shell-skeleton/${3}/g" --expression "s/shell_skeleton/${4}/g" "${5}"' '_' "${SED}" "${NAME}" "${DASH}" "${UNDERSCORE}" '{}' \;
${FIND} . -regextype posix-extended -type f -regex "${INCLUDE_FILTER}" -exec sh -c '${1} --in-place --expression "s/ShellSkeleton/${2}/g" --expression "s/shell-skeleton/${3}/g" --expression "s/shell_skeleton/${4}/g" "${5}"' '_' "${SED}" "${NAME}" "${DASH}" "${UNDERSCORE}" '{}' \;
# shellcheck disable=SC1117
${SED} --in-place --expression "s/bin\/ss/bin\/${INITIALS}/g" README.md Dockerfile
