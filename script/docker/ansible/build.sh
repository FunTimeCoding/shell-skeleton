#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(cd "${DIRECTORY}" || exit 1; pwd)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../../configuration/project.sh"

docker build --tag "${VENDOR_NAME_LOWER}/ansible-playbook" script/docker/ansible/playbook
PUBLIC_KEY=$(cat "${HOME}/.ssh/id_rsa.pub")
docker build --tag "${VENDOR_NAME_LOWER}/ansible-ssh" --build-arg ssh_public_key="${PUBLIC_KEY}" script/docker/ansible/ssh
