# Adapted from https://github.com/CentOS/sig-cloud-instance-build/blob/master/vagrant/centos8.ks

# Perform unattended installation from cdrom (ISO image)
install
cdrom
text
skipx
firstboot --disabled

# Setup bootloader, ensure we get "eth0" as interface
bootloader --timeout=0 --location=mbr --append="no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop"

# Define language and timezone settings
lang en_US.UTF-8
keyboard us
timezone --utc UTC

# Remove all partitions
zerombr
clearpart --drives=sda --all

# Setup partitions
part /boot --ondisk=sda --size=500 --asprimary --fstype=xfs
part pv.01 --ondisk=sda --size=1 --grow

# Setup logical volumes
volgroup vg_system pv.01 --pesize=32768
logvol /var  --name=var  --vgname=vg_system --size=5000  --fstype=xfs
logvol /tmp  --name=tmp  --vgname=vg_system --size=500  --fstype=xfs
logvol /home --name=home --vgname=vg_system --size=500  --fstype=xfs
logvol /     --name=root --vgname=vg_system --size=5000 --fstype=xfs
logvol swap  --name=swap --vgname=vg_system --size=2000

# Set SELinux state of installed system
selinux --enforcing

# Set firewall configuration
firewall --disabled

# Define network settings
network --device=eth0 --bootproto=dhcp

# Define authentication settings
authselect --enableshadow --passalgo=sha512 --kickstart

# Set root password (=vagrant)
rootpw --iscrypted $6$ac/ediK21th2HoRZ$9Y38Cpk9ESK9p7oAJCqhuEyNi7X.weamiG/3f/H4TGvlzrDWeoPA319uULJXIGRhYVKbf.jm5GrzTn7ZEC7fe.

# Add vagrant user in group wheel for sudo
user --name=vagrant --uid=1000 --gid=1000 --password=vagrant --groups=wheel

# Reboot after installation
reboot
 
%packages
@core
bash-completion
man-pages
bzip2
rsync
chrony
#hyperv-daemons
#open-vm-tools
-aic94xx-firmware
-alsa*
-dracut-config-rescue
-iprutils
-ivtv-firmware
-iwl*-firmware
-kexec-tools
-libertas*-firmware
-microcode_ctl
-plymouth*
-postfix
# Don't build rescue initramfs
-dracut-config-rescue
%end

# kdump needs to reserve 160MB + 2bits/4kB RAM, and automatic allocation only
# works on systems with at least 2GB RAM (which excludes most Vagrant boxes)
# CBS doesn't support %addon yet https://bugs.centos.org/view.php?id=12169
%addon com_redhat_kdump --disable
%end
 
%post --log=/tmp/ks-post.log

# Update system
dnf -y upgrade

# Configure locale (prevent 'can't set the locale' errors from ssh connection)
cat >> /etc/environment << EOF
LC_ALL=en_US.utf-8
EOF

# Setup sudoers (no password for wheel group; we've added vagrant to wheel)
cat > /etc/sudoers.d/local << EOF
Defaults:%wheel env_keep += "SSH_AUTH_SOCK"
Defaults:%wheel !requiretty
%wheel ALL=(ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/local

# Fix for https://github.com/CentOS/sig-cloud-instance-build/issues/38
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
EOF

# sshd: disable DNS checks
ex -s /etc/ssh/sshd_config <<EOF
:%substitute/^#\(UseDNS\) yes$/&\r\1 no/
:update
:quit
EOF
cat >>/etc/sysconfig/sshd <<EOF

# Decrease connection time by preventing reverse DNS lookups
# (see https://lists.centos.org/pipermail/centos-devel/2016-July/014981.html
#  and man sshd for more information)
OPTIONS="-u0"
EOF

# Default insecure vagrant key
mkdir -m 0700 -p /home/vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

# Fix for issue #76, regular users can gain admin privileges via su
ex -s /etc/pam.d/su <<'EOF'
# allow vagrant to use su, but prevent others from becoming root or vagrant
/^account\s\+sufficient\s\+pam_succeed_if.so uid = 0 use_uid quiet$/
:append
account		[success=1 default=ignore] \\
				pam_succeed_if.so user = vagrant use_uid quiet
account		required	pam_succeed_if.so user notin root:vagrant
.
:update
:quit
EOF

# systemd should generate a new machine id during the first boot, to
# avoid having multiple Vagrant instances with the same id in the local
# network. /etc/machine-id should be empty, but it must exist to prevent
# boot errors (e.g. systemd-journald failing to start).
:> /etc/machine-id

# Blacklist the floppy module to avoid probing timeouts
echo blacklist floppy > /etc/modprobe.d/nofloppy.conf
chcon -u system_u -r object_r -t modules_conf_t /etc/modprobe.d/nofloppy.conf

# Customize the initramfs
pushd /etc/dracut.conf.d
# Enable VMware PVSCSI support for VMware Fusion guests.
#echo 'add_drivers+=" vmw_pvscsi "' > vmware-fusion-drivers.conf
#echo 'add_drivers+=" hv_netvsc hv_storvsc hv_utils hv_vmbus hid-hyperv "' > hyperv-drivers.conf
# There's no floppy controller, but probing for it generates timeouts
echo 'omit_drivers+=" floppy "' > nofloppy.conf
popd
# Fix the SELinux context of the new files
restorecon -f - <<EOF
/etc/sudoers.d/vagrant
#/etc/dracut.conf.d/vmware-fusion-drivers.conf
#/etc/dracut.conf.d/hyperv-drivers.conf
/etc/dracut.conf.d/nofloppy.conf
EOF

# Rerun dracut for the installed kernel (not the running kernel):
KERNEL_VERSION=$(rpm -q kernel --qf '%{version}-%{release}.%{arch}\n')
dracut -f /boot/initramfs-${KERNEL_VERSION}.img ${KERNEL_VERSION}

# Seal for deployment
rm -rf /etc/ssh/ssh_host_*
rm -rf /etc/udev/rules.d/70-*
%end
