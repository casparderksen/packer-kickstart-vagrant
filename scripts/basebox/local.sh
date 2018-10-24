#!/bin/sh -eux
#
# Install local customizations

# Set local timezone
timedatectl set-timezone Europe/Amsterdam

# Install misc command line tools
yum -y install git-core vim-enhanced wget zip unzip man man-pages rsync screen yum-utils bash-completion

# Install rngd to acquire entropy from CPU (RDRAND instruction)
yum -y install rng-tools
chkconfig rngd on

# Install acpid in order to receive ACPID commands issued by the hypervisor
yum -y install acpid

# Install system tuning daemon and configure virtual guest profile
yum -y install tuned 
tuned-adm profile virtual-guest