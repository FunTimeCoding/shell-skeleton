#!/bin/sh -e

docker run --rm -it -v "$(pwd)/roles:/roles" funtimecoding/ansible-playbook playbook.yml
