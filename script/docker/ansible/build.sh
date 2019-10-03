#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../../configuration/project.sh"

docker build --tag "${VENDOR_NAME_LOWER}/ansible-playbook" script/docker/ansible/playbook
docker build --tag "${VENDOR_NAME_LOWER}/ansible-ssh" script/docker/ansible/ssh
