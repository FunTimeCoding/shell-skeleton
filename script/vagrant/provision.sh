#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive
apt-get --quiet 2 install neovim multitail htop git tree shellcheck
# TODO: Add spell check to check.sh, add hunspell
