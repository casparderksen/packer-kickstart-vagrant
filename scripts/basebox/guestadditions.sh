#!/bin/sh -eux

function install_vbox_guest_additions() {
    yum -y install epel-release
    yum -y install gcc kernel-devel kernel-headers dkms make bzip2 perl 
    mount -t iso9660 -o loop VBoxGuestAdditions.iso /mnt
    cd /mnt
    export KERN_DIR=/usr/src/kernels/$(uname -r)
    ./VBoxLinuxAdditions.run --nox11
    cd -
    umount /mnt
    rm VBoxGuestAdditions.iso
}

case "$PACKER_BUILDER_TYPE" in
virtualbox-*) install_vbox_guest_additions ;;
esac
