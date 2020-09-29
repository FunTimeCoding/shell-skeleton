#!/bin/sh -e

# TODO: Run check, measure and test inside a Docker CI target. Do not pollute the production image.
script/shell/build.sh

if [ "${1}" = --ci-mode ]; then
    script/docker/build.sh --ci-mode
fi
