#!/bin/sh -e

VENDOR_NAME='FunTimeCoding'
export VENDOR_NAME

PROJECT_NAME='shell-skeleton'
export PROJECT_NAME

PROJECT_VERSION='0.1.0'
export PROJECT_VERSION

PACKAGE_VERSION='1'
export PACKAGE_VERSION

MAINTAINER='Alexander Reitzel'
export MAINTAINER

EMAIL='funtimecoding@gmail.com'
export EMAIL

COMBINED_VERSION="${PROJECT_VERSION}-${PACKAGE_VERSION}"
export COMBINED_VERSION

VENDOR_NAME_LOWER=$(echo "${VENDOR_NAME}" | tr '[:upper:]' '[:lower:]')
export VENDOR_NAME_LOWER
