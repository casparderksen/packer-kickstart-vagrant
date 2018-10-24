#!/bin/sh -eux

# Configure grub to wait just 1 second before booting
sed -i 's/^GRUB_TIMEOUT=[0-9]\+$/GRUB_TIMEOUT=1/' /etc/default/grub && grub2-mkconfig -o /boot/grub2/grub.cfg

