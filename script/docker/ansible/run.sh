#!/bin/sh -e

WORKING_DIRECTORY=$(pwd)
docker run --interactive --tty --rm --volume "${WORKING_DIRECTORY}:/project-volume" funtimecoding/ansible-playbook playbook.yml
