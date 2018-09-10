#!/bin/sh -e

# vendor is in here to not break php-skeleton based projects when synchronizing with them.
# .venv is for python-skeleton.
# node_modules is for java-script-skeleton
# target is for java-skeleton
EXCLUDE_FILTER='^.*/(build|tmp|vendor|node_modules|target|\.venv|\.git|\.vagrant|\.idea)/.*$'
export EXCLUDE_FILTER
