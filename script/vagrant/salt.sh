#!/bin/sh -e

MINION_IDENTIFIER="${1}"
CONFIGURATION_PATH="${2}"

if [ ! "${MINION_IDENTIFIER}" = '' ]; then
    mkdir -p /etc/salt/minion.d
    echo "${MINION_IDENTIFIER}" >/etc/salt/minion_id
fi

if [ ! "${CONFIGURATION_PATH}" = '' ]; then
    mkdir -p /etc/salt/minion.d
    cp "${CONFIGURATION_PATH}" /etc/salt/minion.d/minion.conf
fi

grep --quiet CentOS /etc/os-release && CENTOS=true || CENTOS=false

if [ "${CENTOS}" = true ]; then
    yum list installed salt-repo-latest && REPOSITORY_INSTALLED=true || REPOSITORY_INSTALLED=false

    if [ "${REPOSITORY_INSTALLED}" = false ]; then
        yum install --assumeyes https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm
    fi

    yum list installed salt-minion && MINION_INSTALLED=true || MINION_INSTALLED=false

    if [ "${MINION_INSTALLED}" = false ]; then
        yum install --assumeyes salt-minion
    fi
else
    apt-get --quiet 2 install salt-minion
fi
