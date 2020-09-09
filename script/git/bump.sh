#!/bin/sh -e

INCREASE="${1}"

if [ "${INCREASE}" = '' ]; then
    echo "Usage: ${0} INCREASE"
    echo "INCREASE can be patch, minor, major"

    exit 1
fi

VERSION=$(git describe --abbrev=0 --tags 2>/dev/null || echo "0.0.0")
MAJOR=$(echo "${VERSION}" | grep -oE '[0-9]+' | head -1)
MINOR=$(echo "${VERSION}" | grep -oE '[0-9]+' | head -2 | tail -1)
PATCH=$(echo "${VERSION}" | grep -oE '[0-9]+' | head -3 | tail -1)

if [ "${INCREASE}" = 'patch' ]; then
    PATCH=$(echo "${PATCH} + 1" | bc)
elif [ "${INCREASE}" = 'minor' ]; then
    PATCH="0"
    MINOR=$(echo "${MINOR} + 1" | bc)
elif [ "${INCREASE}" = 'major' ]; then
    PATCH="0"
    MINOR="0"
    MAJOR=$(echo "${MAJOR} + 1" | bc)
else
    echo "Unexpected increase: ${INCREASE}"

    exit 1
fi

TAG="${MAJOR}.${MINOR}.${PATCH}"
echo "${TAG}"
git tag "${TAG}"
git push origin --tags
