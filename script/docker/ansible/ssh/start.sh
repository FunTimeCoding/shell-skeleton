#!/bin/sh -e

# Enable rsyslog daemon so that SSHD log file is created.
rsyslogd

/usr/sbin/sshd -D
