
# grubby

## Links and reference
 * [Red Hat - grubby](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/assembly_making-persistent-changes-to-the-grub-boot-loader_managing-monitoring-and-updating-the-kernel#proc_viewing-the-grub-2-menu-entry-for-a-kernel_assembly_making-persistent-changes-to-the-grub-boot-loader)
 * [Oracle - grubby](https://docs.oracle.com/en/operating-systems/oracle-linux/9/boot/boot-UsinggrubbyToManageKernels.html)

## Get all kernel menuentry
```shell
vagrant@practice-rocky9 sysconfig]$ sudo grubby --info=ALL
index=0
kernel="/boot/vmlinuz-5.14.0-362.8.1.el9_3.x86_64"
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=256M"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-362.8.1.el9_3.x86_64.img"
title="Rocky Linux (5.14.0-362.8.1.el9_3.x86_64) 9.3 (Blue Onyx)"
id="6e61fa754bd94e588c352bb961b033d6-5.14.0-362.8.1.el9_3.x86_64"
index=1
kernel="/boot/vmlinuz-5.14.0-503.35.1.el9_5.x86_64+debug"
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-503.35.1.el9_5.x86_64+debug.img"
title="Rocky Linux (5.14.0-503.35.1.el9_5.x86_64+debug) 9.3 (Blue Onyx) with debugging"
id="dd3b87f635c84d26b5b9830ca4db4979-5.14.0-503.35.1.el9_5.x86_64+debug"
index=2
kernel="/boot/vmlinuz-5.14.0-503.35.1.el9_5.x86_64"
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-503.35.1.el9_5.x86_64.img"
title="Rocky Linux (5.14.0-503.35.1.el9_5.x86_64) 9.3 (Blue Onyx)"
id="dd3b87f635c84d26b5b9830ca4db4979-5.14.0-503.35.1.el9_5.x86_64"
[vagrant@practice-rocky9 sysconfig]$
```

## Get default kernel
```shell
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --default-kernel
/boot/vmlinuz-5.14.0-503.35.1.el9_5.x86_64
[vagrant@practice-rocky9 sysconfig]$ 
```

## Get default kernel index
```shell
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --default-index
2
[vagrant@practice-rocky9 sysconfig]$ 
```

## Set default kernel
### List available kernel and default kernel and its index
```shell

[vagrant@practice-rocky9 sysconfig]$ sudo grubby --info=ALL
index=0
kernel="/boot/vmlinuz-5.14.0-362.8.1.el9_3.x86_64"
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=256M vconsole.font=latarcyrheb-sun32"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-362.8.1.el9_3.x86_64.img"
title="Rocky Linux (5.14.0-362.8.1.el9_3.x86_64) 9.3 (Blue Onyx)"
id="6e61fa754bd94e588c352bb961b033d6-5.14.0-362.8.1.el9_3.x86_64"
index=1
kernel="/boot/vmlinuz-5.14.0-503.35.1.el9_5.x86_64+debug"
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-503.35.1.el9_5.x86_64+debug.img"
title="Rocky Linux (5.14.0-503.35.1.el9_5.x86_64+debug) 9.3 (Blue Onyx) with debugging"
id="dd3b87f635c84d26b5b9830ca4db4979-5.14.0-503.35.1.el9_5.x86_64+debug"
index=2
kernel="/boot/vmlinuz-5.14.0-503.35.1.el9_5.x86_64"
args="ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-503.35.1.el9_5.x86_64.img"
title="Rocky Linux (5.14.0-503.35.1.el9_5.x86_64) 9.3 (Blue Onyx)"
id="dd3b87f635c84d26b5b9830ca4db4979-5.14.0-503.35.1.el9_5.x86_64"
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --default-kernel
/boot/vmlinuz-5.14.0-503.35.1.el9_5.x86_64
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --default-index
2
```
### Set the default kernel with respective index nunber
```shell
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --set-default 0
The default is /boot/loader/entries/6e61fa754bd94e588c352bb961b033d6-5.14.0-362.8.1.el9_3.x86_64.conf with index 0 and kernel /boot/vmlinuz-5.14.0-362.8.1.el9_3.x86_64
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --default-kernel
/boot/vmlinuz-5.14.0-362.8.1.el9_3.x86_64
[vagrant@practice-rocky9 sysconfig]$ 
```

## Editing kernel args
```shell
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --info 0
index=0
kernel="/boot/vmlinuz-5.14.0-362.8.1.el9_3.x86_64"
args="ro no_timer_check net.ifnames=0 biosdevname=0 elevator=noop crashkernel=256M console=ttyS0,115200n8"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-362.8.1.el9_3.x86_64.img"
title="Rocky Linux (5.14.0-362.8.1.el9_3.x86_64) 9.3 (Blue Onyx)"
id="6e61fa754bd94e588c352bb961b033d6-5.14.0-362.8.1.el9_3.x86_64"
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --args=vconsole.font=latarcyrheb-sun32 --update-kernel 0
[vagrant@practice-rocky9 sysconfig]$ sudo grubby --info 0
index=0
kernel="/boot/vmlinuz-5.14.0-362.8.1.el9_3.x86_64"
args="ro no_timer_check net.ifnames=0 biosdevname=0 elevator=noop crashkernel=256M console=ttyS0,115200n8 vconsole.font=latarcyrheb-sun32"
root="UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a"
initrd="/boot/initramfs-5.14.0-362.8.1.el9_3.x86_64.img"
title="Rocky Linux (5.14.0-362.8.1.el9_3.x86_64) 9.3 (Blue Onyx)"
id="6e61fa754bd94e588c352bb961b033d6-5.14.0-362.8.1.el9_3.x86_64"
[vagrant@practice-rocky9 sysconfig]$
```