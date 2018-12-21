#!/bin/sh -e

# For Salt for provisioning only.
mkdir -p tmp/salt
cp configuration/minion.yaml tmp/salt/minion.conf

vagrant up
