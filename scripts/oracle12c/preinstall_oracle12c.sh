#!/bin/sh -eux

# Extend swap space
swapoff /dev/vg_system/swap
lvextend -L 4GB /dev/vg_system/swap 
mkswap /dev/vg_system/swap 
swapon /dev/vg_system/swap 

# Extend root filesystem
lvextend -L 20G /dev/vg_system/root
xfs_growfs /dev/vg_system/root

# Extend tmp filesystem
lvextend -L 4G /dev/vg_system/tmp
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

# Configure kernel parameters
cat << --- > /etc/sysctl.d/98-oracle.conf
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 9000 65500
---

# Load kernel parameters
/sbin/sysctl -p
/sbin/sysctl -a

# Configure limits
cat << --- > /etc/security/limits.d/oracle-database-server-12cR2.conf
oracle   soft   nofile    1024
oracle   hard   nofile    65536
oracle   soft   nproc    16384
oracle   hard   nproc    16384
oracle   soft   stack    10240
oracle   hard   stack    32768
oracle   hard   memlock    134217728
oracle   soft   memlock    134217728
---

# Install required packages
yum install -y binutils compat-libcap1 compat-libstdc++-33 compat-libstdc++-33.i686 glibc glibc.i686 glibc-devel glibc-devel.i686 ksh libaio libaio.i686 libaio-devel libaio-devel.i686 libX11 libX11.i686 libXau libXau.i686 libXi libXi.i686 libXtst libXtst.i686 libgcc libgcc.i686 libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 libxcb libxcb.i686 make nfs-utils net-tools smartmontools sysstat unixODBC unixODBC-devel

# Set Secure Linux to permissive
sed -e 's/SELINUX=enforcing/SELINUX=permissive/' -i /etc/selinux/config
setenforce Permissive

# Disable Transparent Huge Pages (requires reboot)
for kernel in /boot/vmlinuz-*; do
    grubby --update-kernel="${kernel}" --args="transparent_hugepage=never"
done

# Run time disable Transparent Huge Pages (without reboot)
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag
