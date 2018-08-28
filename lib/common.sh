#!/bin/sh -e

# vendor is in here to not break php-skeleton based projects when synchronizing with them.
# .venv is for python-skeleton.
EXCLUDE_FILTER='^.*/(build|tmp|vendor|\.venv|\.git|\.vagrant|\.idea)/.*$'
export EXCLUDE_FILTER
