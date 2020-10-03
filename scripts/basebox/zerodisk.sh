#!/bin/sh -eux

# Zero out free space on disk volumes
volumes=( /boot /var /tmp /home / )
for volume in "${volumes[@]}"; do
    dd if=/dev/zero of="${volume}/EMPTY" bs=1M oflag=direct
    rm -f "${volume}/EMPTY"
done

# Zero out swap space
swap=$(cat /proc/swaps | tail -n1 | awk '{print $1}')
swapoff "${swap}"
dd if=/dev/zero of="${swap}" bs=1M oflag=direct
mkswap -f "${swap}"
swapon "${swap}"

# Sync filesystems
sync
