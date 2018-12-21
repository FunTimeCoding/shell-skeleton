#!/bin/sh -e

if [ ! -f tmp/bootstrap-salt.sh ]; then
    wget --output-document tmp/bootstrap-salt.sh https://bootstrap.saltstack.com
fi

mkdir -p tmp/salt
cp configuration/minion.yaml tmp/salt/minion.conf

vagrant up
