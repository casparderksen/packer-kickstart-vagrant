#!/bin/sh -eux

# Cleanup old kernels and packages
dnf -y remove $(dnf repoquery --installonly --latest-limit=-1 -q)
dnf clean all

# Cleanup temp files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Remove SSH host keys
rm -f /etc/ssh/*key*

# Generate new machine id during first boot
:> /etc/machine-id

# Cleanup root user directory
rm -f /root/anaconda-ks.cfg 
rm -f /root/original-ks.cfg

# Cleanup old log files
rm -f /var/log/*.log
rm -f /var/log/anaconda/*
rm -f /var/log/vbox*

# Truncate logs
:> /var/log/audit/audit.log
:> /var/log/wtmp
:> /var/log/lastlog
