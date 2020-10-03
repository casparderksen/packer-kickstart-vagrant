#!/bin/sh -eux
#
# Install local customizations

# Set local timezone
timedatectl set-timezone Europe/Amsterdam

# Install misc command line tools
dnf -y  install git-core vim-enhanced wget

# Install acpid in order to receive ACPID commands issued by the hypervisor
dnf -y install acpid