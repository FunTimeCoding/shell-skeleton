#!/bin/sh -e

# shellcheck source=/dev/null
. "${HOME}/.virtualization-tools.sh"
docker login "${PRIVATE_REGISTRY_SERVER}"
