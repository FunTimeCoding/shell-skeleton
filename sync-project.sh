#!/bin/sh -e

usage()
{
    echo "Usage: ${0} TARGET_PROJECT"
}

if [ "${1}" = "" ]; then
    usage

    exit 1
fi

TARGET_PROJECT="${1}"

if [ ! -d "${TARGET_PROJECT}" ]; then
    echo "Target directory does not exist."

    exit 1
fi

cp ./*.md "${TARGET_PROJECT}"
cp ./*.sh "${TARGET_PROJECT}"
rm "${TARGET_PROJECT}/init-project.sh"
rm "${TARGET_PROJECT}/sync-project.sh"
echo "Done. Files were copied to ${TARGET_PROJECT}. Review those changes."
