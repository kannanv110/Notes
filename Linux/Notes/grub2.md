# grub2

## Links and References
 * [Red Hat Document](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/assembly_making-temporary-changes-to-the-grub-menu_managing-monitoring-and-updating-the-kernel#introduction-to-grub2_assembly_making-temporary-changes-to-the-grub-menu)

## Reset root password
 * Select and edit grub entry
 * select the line starting with `linux`, `linux16` or `linuxefi`
 * go to end of the line and add `rd.break`
 * Once the system booted perform below steps to recover root password
 ```shell
 # mount -o remount,rw /sysroot
 # chroot /sysroot
 # passwd
 New password:
 Re-confirm password:
 # touch /.autorelabel
 # exit
 # reboot
 ```

