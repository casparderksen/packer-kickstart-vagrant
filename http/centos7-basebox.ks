# Perform unattended installation from cdrom (ISO image)
install
cdrom
text
skipx
unsupported_hardware
firstboot --disabled

# Define language and timezone settings
lang en_US.UTF-8
keyboard us
timezone --utc UTC

# Set SELinux state of installed system
selinux --enforcing

# Remove all partitions
zerombr
clearpart --drives=sda --all

# Setup bootloader, ensure we get "eth0" as interface
bootloader --timeout=0 --location=mbr --append="no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0"

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

# Set firewall configuration
firewall --disabled

# Define network settings
network --device=eth0 --bootproto=dhcp
network --hostname=localhost.localdomain

# Define authentication settings
auth --enableshadow --passalgo=sha512 --kickstart

# Set root password (=vagrant)
rootpw --iscrypted $6$ac/ediK21th2HoRZ$9Y38Cpk9ESK9p7oAJCqhuEyNi7X.weamiG/3f/H4TGvlzrDWeoPA319uULJXIGRhYVKbf.jm5GrzTn7ZEC7fe.

# Add vagrant user
user --name=vagrant --uid=1000 --gid=1000 --password=vagrant --groups=wheel

# Reboot after installation
reboot
 
%packages --nobase --excludedocs
@core --nodefaults
-aic94xx-firmware
-alsa*
-dracut-config-rescue
-iprutils
-ivtv-firmware
-iwl*-firmware
-kexec-tools
-libertas*-firmware
-microcode_ctl
-NetworkManager*
-plymouth*
-postfix
%end 
 
%post --log=/tmp/ks-post.log

# Update system
yum -y install deltarpm
yum -y update

# Enable network interface
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO="dhcp"
IPV6INIT="no"
NM_CONTROLLED="no"
ONBOOT="yes"
TYPE="Ethernet"
PERSISTENT_DHCLIENT="yes"
EOF

# Setup sudoers
cat <<EOF > /etc/sudoers.d/local
Defaults:%wheel env_keep += "SSH_AUTH_SOCK"
Defaults:%wheel !requiretty
%wheel ALL=(ALL) NOPASSWD: ALL
EOF
chmod 0440 /etc/sudoers.d/local

# Blacklist the floppy module to avoid probing timeouts
echo blacklist floppy > /etc/modprobe.d/nofloppy.conf
chcon -u system_u -r object_r -t modules_conf_t /etc/modprobe.d/nofloppy.conf

# Customize the initramfs, omit floppy driver
# There's no floppy controller, but probing for it generates timeouts
echo 'omit_drivers+=" floppy "' > /etc/dracut.conf.d/nofloppy.conf

# Fix the SELinux context of the new files
restorecon -f - <<EOF
/etc/sudoers.d/local
/etc/dracut.conf.d/nofloppy.conf
EOF

# Rerun dracut for the installed kernel (not the running kernel):
KERNEL_VERSION=$(rpm -q kernel --qf '%{version}-%{release}.%{arch}\n')
dracut -f /boot/initramfs-${KERNEL_VERSION}.img ${KERNEL_VERSION}

%end
