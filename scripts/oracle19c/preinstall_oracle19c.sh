#!/bin/sh -eux

# Extend swap space
swapoff /dev/vg_system/swap
lvextend -L 8GB /dev/vg_system/swap
mkswap /dev/vg_system/swap 
swapon /dev/vg_system/swap 

# Extend root filesystem
lvextend -L 20G /dev/vg_system/root
xfs_growfs /dev/vg_system/root

# Extend tmp filesystem
lvextend -L 4G /dev/vg_system/tmp
xfs_growfs /dev/vg_system/tmp

# Create staging directory for uploading and extracting files
mkdir -p ${STAGING_DIR}
chown -R vagrant:vagrant ${STAGING_DIR}

# Set hostname
hostnamectl set-hostname oracle19c.localdomain

# Determine IP address
ip_address=$(ip address show dynamic | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')

# Add fully qualified machine name to hosts
echo "${ip_address} $(hostname -s) $(hostname)" >> /etc/hosts

# Install and perform Oracle 19c installation prerequisites
#TODO file no longer available online
# dnf -y localinstall ${STAGING_DIR}/oracle-database-preinstall-19c-1.0-1.el8.x86_64.rpm
dnf install -y https://yum.oracle.com/repo/OracleLinux/OL8/baseos/latest/x86_64/getPackage/oracle-database-preinstall-19c-1.0-1.el8.x86_64.rpm

# Set Secure Linux to permissive
sed -e 's/SELINUX=enforcing/SELINUX=permissive/' -i /etc/selinux/config
setenforce Permissive

# Disable firewall
systemctl stop firewalld
systemctl disable firewalld

# Disable Transparent Huge Pages (requires reboot)
for kernel in /boot/vmlinuz-*; do
    grubby --update-kernel="${kernel}" --args="transparent_hugepage=never"
done

# Disable Transparent Huge Pages (without reboot)
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag

# Amend tuned profile to disable Transparent Huge Pages
mkdir /etc/tuned/virtual-guest-nothp
cat <<EOF > /etc/tuned/virtual-guest-nothp/tuned.conf
[main]
include= virtual-guest

[vm]
transparent_hugepages=never
EOF
chmod +x /etc/tuned/virtual-guest-nothp/tuned.conf
tuned-adm profile virtual-guest-nothp