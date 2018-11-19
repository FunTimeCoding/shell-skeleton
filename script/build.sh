#!/bin/sh -e

rm -rf build
script/check.sh --ci-mode

# TODO: Finish implementation.
#SYSTEM=$(uname)
#
#if [ "${SYSTEM}" = Linux ]; then
#    script/debian/package.sh
#fi

# TODO: Finish implementation.
#script/docker/build.sh
