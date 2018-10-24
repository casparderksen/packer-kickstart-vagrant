#!/bin/sh -eux

# Disable DNS checks
sed -i -e 's/^#\(UseDNS\) yes$/UseDNS no/' /etc/ssh/sshd_config

# Prevent reverse DNS lookups
cat <<EOF >> /etc/sysconfig/sshd
# Decrease connection time by preventing reverse DNS lookups
# (see https://lists.centos.org/pipermail/centos-devel/2016-July/014981.html)
OPTIONS="-u0"
EOF
