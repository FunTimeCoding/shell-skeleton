#!/bin/sh -e

# shellcheck disable=SC2016
jjm --locator https://github.com/FunTimeCoding/shell-skeleton.git --build-command ./build.sh > job.xml
