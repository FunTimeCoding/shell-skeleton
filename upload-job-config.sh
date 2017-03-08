#!/bin/sh -e

~/src/jenkins-tools/bin/delete-job.sh shell-skeleton || true
~/src/jenkins-tools/bin/put-job.sh shell-skeleton job.xml
