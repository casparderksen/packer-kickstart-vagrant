#!/bin/sh -eux

# Cleanup old kernels and packages
yum -y install yum-utils
package-cleanup -y --old kernels --count=1
yum clean all

# Determine network interface
version=$(rpm -q --queryformat '%{VERSION}' centos-release)
case "${version}" in
6)
    interface=eth0
    ;;
7)
    interface=$(ip address show dynamic | head -1 | awk -F': ' '{print $2}')
    ;;
esac

# Reset networking interfaces
sed -i -e '/^HWADDR=/d' -e '/^UUID=/d' /etc/sysconfig/network-scripts/ifcfg-${interface}
rm -f /etc/udev/rules.d/70-*
rm -f /var/lib/dhclient/dhclient-*

# Cleanup temp files
rm -rf /tmp/*
rm -rf /var/tmp/*

# Remove SSH host keys
rm -f /etc/ssh/*key*

# Generate new machine id during first boot (RHEL7)
[ -f /etc/machine-id ] && cat /dev/null > /etc/machine-id

# Cleanup root user directory
rm -f /root/anaconda-ks.cfg 
rm -f /root/original-ks.cfg
rm -f /root/install.log*

# Stop logging services
/sbin/service rsyslog stop
/sbin/service auditd stop

# Rotate logs and cleanup old log files
/usr/sbin/logrotate -f /etc/logrotate.conf
rm -f /var/log/*-???????? /var/log/*.gz
rm -f /var/log/dmesg.old
rm -f /var/log/anaconda.*
rm -f /var/log/vbox* /var/log/VBox*

# Truncate logs
cat /dev/null > /var/log/audit/audit.log
cat /dev/null > /var/log/wtmp
cat /dev/null > /var/log/lastlog
