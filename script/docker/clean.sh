#!/bin/sh -e

# Remove container.
docker rm shell-skeleton

# Remove image.
docker rmi funtimecoding/shell-skeleton

# Remove dangling image identifiers, and more.
docker system prune
