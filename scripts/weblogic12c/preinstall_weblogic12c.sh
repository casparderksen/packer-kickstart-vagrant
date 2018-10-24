#!/bin/sh -eux

# Extend root filesystem
lvextend -L 10G /dev/vg_system/root
xfs_growfs /dev/vg_system/root

# Extend tmp filesystem
lvextend -L 1G /dev/vg_system/tmp
xfs_growfs /dev/vg_system/tmp

# Create staging directory for uploading and excting files
mkdir -p ${STAGING_DIR}
chown -R vagrant:vagrant ${STAGING_DIR}

# Install zip utils
yum -y install zip unzip

# Determine IP address
ip=$(ip address show dynamic | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')

# Add fully qualified machine name to hosts.
sed -ie "s/[0-9\.]\+\s\+vagrant/${ip} vagrant vagrant.localdomain/" /etc/hosts
