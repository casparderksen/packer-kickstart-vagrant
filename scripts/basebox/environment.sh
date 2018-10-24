#!/bin/sh -eux

# Configure environment (fixes "cannot change locale (UTF-8)"" warning)
cat <<EOF >> /etc/environment
LANG=en_US.utf-8
LC_ALL=en_US.utf-8
EOF