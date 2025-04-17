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

## Get the SELinux context for files, process and ports
```shell
[vagrant@practice-rocky9 ~]$ ls -lZ
total 4
-rw-r--r--. 1 vagrant vagrant unconfined_u:object_r:user_home_t:s0 14 Apr 17 09:47 test1.html
[vagrant@practice-rocky9 ~]$

[vagrant@practice-rocky9 ~]$ ps -Zaux |egrep "sshd|httpd|bind|systemd"
system_u:system_r:init_t:s0     root           1  0.0  0.2 108528 18284 ?        Ss   05:52   0:04 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
system_u:system_r:syslogd_t:s0  root         476  0.0  0.1  26276  9444 ?        Ss   05:52   0:00 /usr/lib/systemd/systemd-journald
system_u:system_r:udev_t:s0-s0:c0.c1023 root 491  0.0  0.1  34968 13032 ?        Ss   05:52   0:03 /usr/lib/systemd/systemd-udevd
system_u:system_r:rpcbind_t:s0  rpc          561  0.0  0.0  13244  5572 ?        Ss   05:52   0:00 /usr/bin/rpcbind -w -f
system_u:system_r:systemd_logind_t:s0 root   591  0.0  0.1  29800 12596 ?        Ss   05:52   0:00 /usr/lib/systemd/systemd-logind
system_u:system_r:sshd_t:s0-s0:c0.c1023 root 657  0.0  0.1  15852  9316 ?        Ss   05:52   0:00 sshd: /usr/sbin/sshd -D -u0 [listener] 0 of 10-100 startups
system_u:system_r:httpd_t:s0    root         678  0.0  0.1  20152 11636 ?        Ss   05:52   0:01 /usr/sbin/httpd -DFOREGROUND
system_u:system_r:httpd_t:s0    apache       729  0.0  0.0  21580  7384 ?        S    05:52   0:00 /usr/sbin/httpd -DFOREGROUND
system_u:system_r:httpd_t:s0    apache       730  0.0  0.1 1439756 11700 ?       Sl   05:52   0:04 /usr/sbin/httpd -DFOREGROUND
system_u:system_r:httpd_t:s0    apache       731  0.0  0.1 1439756 10928 ?       Sl   05:52   0:04 /usr/sbin/httpd -DFOREGROUND
system_u:system_r:httpd_t:s0    apache       732  0.0  0.1 1570892 12976 ?       Sl   05:52   0:04 /usr/sbin/httpd -DFOREGROUND
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 vagrant 971 0.0  0.1 23448 14716 ? Ss 05:52   0:00 /usr/lib/systemd/systemd --user
system_u:system_r:sshd_t:s0-s0:c0.c1023 root 3073 0.0  0.1  18824 11468 ?        Ss   05:53   0:00 sshd: vagrant [priv]
unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 vagrant 3076 0.0  0.0 19184 7420 ? S 05:53   0:01 sshd: vagrant@pts/0
system_u:system_r:httpd_t:s0    apache      5533  0.0  0.2 1439756 17068 ?       Sl   09:49   0:00 /usr/sbin/httpd -DFOREGROUND

[vagrant@practice-rocky9 ~]$ sudo netstat -Ztulpen
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name     Security Context                                 
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          20691      657/sshd: /usr/sbin  system_u:system_r:sshd_t:s0-s0:c0.c1023           
tcp        0      0 0.0.0.0:111             0.0.0.0:*               LISTEN      0          18395      1/systemd            system_u:system_r:init_t:s0                       
tcp6       0      0 :::22                   :::*                    LISTEN      0          20693      657/sshd: /usr/sbin  system_u:system_r:sshd_t:s0-s0:c0.c1023           
tcp6       0      0 :::80                   :::*                    LISTEN      0          19305      678/httpd            system_u:system_r:httpd_t:s0                      
tcp6       0      0 :::111                  :::*                    LISTEN      0          18407      1/systemd            system_u:system_r:init_t:s0                       
udp        0      0 0.0.0.0:111             0.0.0.0:*                           0          18401      1/systemd            system_u:system_r:init_t:s0                       
udp        0      0 127.0.0.1:323           0.0.0.0:*                           0          20479      599/chronyd          system_u:system_r:chronyd_t:s0                    
udp6       0      0 :::111                  :::*                                0          18413      1/systemd            system_u:system_r:init_t:s0                       
udp6       0      0 ::1:323                 :::*                                0          20480      599/chronyd          system_u:system_r:chronyd_t:s0                    
[vagrant@practice-rocky9 ~]$ 
```

## List SELinux user policy modes
```shell
[vagrant@practice-rocky9 ~]$ sudo semanage user -l

                Labeling   MLS/       MLS/                          
SELinux User    Prefix     MCS Level  MCS Range                      SELinux Roles

guest_u         user       s0         s0                             guest_r
root            user       s0         s0-s0:c0.c1023                 staff_r sysadm_r system_r unconfined_r
staff_u         user       s0         s0-s0:c0.c1023                 staff_r sysadm_r system_r unconfined_r
sysadm_u        user       s0         s0-s0:c0.c1023                 sysadm_r
system_u        user       s0         s0-s0:c0.c1023                 system_r unconfined_r
unconfined_u    user       s0         s0-s0:c0.c1023                 system_r unconfined_r
user_u          user       s0         s0                             user_r
xguest_u        user       s0         s0                             xguest_r
[vagrant@practice-rocky9 ~]$ 
```
## List SELinux file context policy modes
```shell
[vagrant@practice-rocky9 ~]$ sudo semanage fcontext -l |grep /var/www/html
SELinux fcontext                                   type               Context
/var/www/html(/.*)?/sites/default/files(/.*)?      all files          system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html(/.*)?/sites/default/settings\.php    regular file       system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html(/.*)?/uploads(/.*)?                  all files          system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html(/.*)?/wp-content(/.*)?               all files          system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html(/.*)?/wp_backups(/.*)?               all files          system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html/[^/]*/cgi-bin(/.*)?                  all files          system_u:object_r:httpd_sys_script_exec_t:s0 
/var/www/html/cgi/munin.*                          all files          system_u:object_r:munin_script_exec_t:s0 
/var/www/html/configuration\.php                   all files          system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html/munin(/.*)?                          all files          system_u:object_r:munin_content_t:s0 
/var/www/html/munin/cgi(/.*)?                      all files          system_u:object_r:munin_script_exec_t:s0 
/var/www/html/nextcloud/data(/.*)?                 all files          system_u:object_r:httpd_sys_rw_content_t:s0 
/var/www/html/owncloud/data(/.*)?                  all files          system_u:object_r:httpd_sys_rw_content_t:s0 
[vagrant@practice-rocky9 ~]$
```

## Change file context
```shell

```

## SELinux Policy Behavior

SELinux policy is not something that replaces traditional DAC security. If a DAC rule prohibits a user access to a file, SELinux policy rules won’t be evaluated because the first line of defense has already blocked access. SELinux security decisions come into play after DAC security has been evaluated.

When an SELinux-enabled system starts, the policy is loaded into memory. SELinux policy comes in modular format, much like the kernel modules loaded at boot time. And just like the kernel modules, they can be dynamically added and removed from memory at run time. The policy store used by SELinux keeps track of the modules that have been loaded. The sestatus command shows the policy store name. The `semodule -l` command lists the SELinux policy modules currently loaded into memory.

`semodule` can be used for a number other tasks like installing, removing, reloading, upgrading, enabling and disabling SELinux policy modules.

```shell
[vagrant@practice-rocky9 mytest]$ sudo semodule -l |head
abrt
accountsd
acct
afs
aiccu
aide
ajaxterm
alsa
amanda
amtu
[vagrant@practice-rocky9 mytest]$ 
```

We can't read the policy module file but we can edit their settings using boolean option with semanage.

```shell
[vagrant@practice-rocky9 mytest]$ sudo semanage boolean -l |more
SELinux boolean                State  Default Description

abrt_anon_write                (off  ,  off)  Allow abrt to anon write
abrt_handle_event              (off  ,  off)  Allow abrt to handle event
abrt_upload_watch_anon_write   (on   ,   on)  Allow abrt to upload watch anon write
antivirus_can_scan_system      (off  ,  off)  Allow antivirus to can scan system
antivirus_use_jit              (off  ,  off)  Allow antivirus to use jit
auditadm_exec_content          (on   ,   on)  Allow auditadm to exec content
authlogin_nsswitch_use_ldap    (off  ,  off)  Allow authlogin to nsswitch use ldap
authlogin_radius               (off  ,  off)  Allow authlogin to radius
authlogin_yubikey              (off  ,  off)  Allow authlogin to yubikey
awstats_purge_apache_log_files (off  ,  off)  Allow awstats to purge apache log files
boinc_execmem                  (on   ,   on)  Allow boinc to execmem
```

Get setting for particular module
```shell
[vagrant@practice-rocky9 mytest]$ sudo getsebool ftpd_anon_write
ftpd_anon_write --> off
[vagrant@practice-rocky9 mytest]$ 
```

Change the boolean to enable it
```shell
[vagrant@practice-rocky9 mytest]$ sudo setsebool ftpd_anon_write on
[vagrant@practice-rocky9 mytest]$ sudo getsebool ftpd_anon_write
ftpd_anon_write --> on
[vagrant@practice-rocky9 mytest]$
```

