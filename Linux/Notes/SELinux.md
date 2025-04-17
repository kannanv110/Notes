# SELINUX

## Links and references
 * [DigitalOcean - Intro to SELinux](https://www.digitalocean.com/community/tutorials/an-introduction-to-selinux-on-centos-7-part-1-basic-concepts)
 
## SELinux Modes
SELinux can be in any of three possible modes:

 * **Enforcing:** In enforcing mode SELinux will enforce its policy on the Linux system and make sure any unauthorized access attempts by users and processes are denied. The access denials are also written to relevant log files.
 * **Permissive:** Permissive mode is like a semi-enabled state. SELinux doesn’t apply its policy in permissive mode, so no access is denied. However any policy violation is still logged in the audit logs. It’s a great way to test SELinux before enforcing it.
 * **Disabled:** The disabled mode is self-explanatory – the system won’t be running with enhanced security.

## Get current SELinux mode
```shell
[vagrant@practice-rocky9 log]$ getenforce
Enforcing
[vagrant@practice-rocky9 log]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
[vagrant@practice-rocky9 log]$ 
```

## SELinux config file location
```shell
[vagrant@practice-rocky9 log]$ sudo cat /etc/selinux/config 

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
# See also:
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/using_selinux/changing-selinux-states-and-modes_using-selinux#changing-selinux-modes-at-boot-time_changing-selinux-states-and-modes
#
# NOTE: Up to RHEL 8 release included, SELINUX=disabled would also
# fully disable SELinux during boot. If you need a system with SELinux
# fully disabled instead of SELinux running with no policy loaded, you
# need to pass selinux=0 to the kernel command line. You can use grubby
# to persistently set the bootloader to boot with selinux=0:
#
#    grubby --update-kernel ALL --args selinux=0
#
# To revert back to SELinux enabled:
#
#    grubby --update-kernel ALL --remove-args selinux
#
SELINUX=enforcing
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted


[vagrant@practice-rocky9 log]$ 

```

## Steps to Activate SELinux
 * First set the SELINUX mode as `permissive` and reboot the server
 * This will apply selinux context on the file and will not apply the policy and denied the access.
 * If any of the file have invalid context then that may prevent the machine to boot.
 * Once the server booted check for any error on log file
 * search for `"SELinux is preventing"` on file `/var/log/messages`
 * Also look for entry `SELinux` on /var/log/messages
 * fix context for any reported file and change the mode to `enforcing` and reboot the server.
 * Once booted then check for mode and status of SELinux.

 ## Change the mode between `permissive` and `enforcing`
 We can change the mode between `permissive` and `enforcing` but we can't change between `disabled`.
 ```shell
 vagrant@practice-rocky9 log]$ getenforce
Enforcing
[vagrant@practice-rocky9 log]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33

[vagrant@practice-rocky9 log]$ sudo setenforce permissive
[vagrant@practice-rocky9 log]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33
[vagrant@practice-rocky9 log]$ getenforce 
Permissive
[vagrant@practice-rocky9 log]$ 
```
