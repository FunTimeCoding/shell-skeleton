#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../configuration/project.sh"

script/docker/remove.sh

# Remove image.
docker rmi "${VENDOR_NAME_LOWER}/${PROJECT_NAME_DASH}"

# Remove dangling image identifiers, and more.
docker system prune
