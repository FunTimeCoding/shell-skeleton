#!/bin/sh -e

grep --quiet CentOS /etc/os-release && CENTOS=true || CENTOS=false

if [ "${CENTOS}" = true ]; then
    yum update --assumeyes
else
    sed --in-place 's/deb.debian.org/ftp.de.debian.org/' /etc/apt/sources.list
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get --quiet 2 update
    # TODO: Uncomment once updating does not prompt for Grub update anymore on Stretch.
    #sudo apt-get --quiet 2 upgrade
    #sudo apt-get --quiet 2 dist-upgrade
fi
