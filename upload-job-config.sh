#!/bin/sh -e

~/Code/Personal/jenkins-tools/bin/delete-job.sh shell-skeleton || true
~/Code/Personal/jenkins-tools/bin/put-job.sh shell-skeleton job.xml
