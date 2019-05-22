# Tips

## Extend swap space (e.g. for Oracle RDBMS)

    swapoff /dev/vg_system/lv_swap
    lvextend -L 4GB /dev/vg_system/lv_swap 
    mkswap /dev/vg_system/lv_swap 
    swapon /dev/vg_system/lv_swap 

## Create new logical volume

    lvcreate -L5G -n lv_app vg_system

## Extend logical volume

    lvextend -L 32G /dev/vg_system/lv_root
    xfs_growfs /dev/vg_system/lv_root

