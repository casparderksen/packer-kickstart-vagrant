#!/bin/sh -x

# Extend file systems
lvextend -L 20G /dev/vg_system/var
xfs_growfs /dev/vg_system/var