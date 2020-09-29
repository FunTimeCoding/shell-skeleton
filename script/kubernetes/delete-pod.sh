#!/bin/sh -e

POD_NAME="${1}"

if [ "${POD_NAME}" = '' ]; then
    echo "Usage: ${0} POD_NAME"

    exit 1
fi

# TODO: Guess the full POD_NAME with the variable suffix.
kubectl delete pod "${POD_NAME}"
