#!/bin/sh -eux

dnf -y install epel-release
dnf -y install gcc kernel-devel kernel-headers dkms make bzip2 perl
export KERN_DIR=/usr/src/kernels/$(uname -r)

mount -t iso9660 -o loop VBoxGuestAdditions.iso /mnt
cd /mnt
./VBoxLinuxAdditions.run --nox11
cd -
umount /mnt

rm VBoxGuestAdditions.iso
