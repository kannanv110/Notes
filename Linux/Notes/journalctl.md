# Journalctl

## Links and reference
 * [DigitalOcean - journalctl](https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs)
 
## Get system log
```bash
journalctl
```

## Enable to save past boots
```shell
/etc/systemd/journald.conf
. . .
[Journal]
Storage=persistent
```

## List the boots
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl --list-boots
IDX BOOT ID                          FIRST ENTRY                 LAST ENTRY                 
 -1 ee1f97d3c1924b0da9bc7db2223faec3 Fri 2025-04-18 09:54:58 IST Fri 2025-04-18 09:55:50 IST
  0 dbe7725896094acfac33095b5bfa5ab5 Fri 2025-04-18 09:55:57 IST Fri 2025-04-18 10:21:21 IST
[vagrant@practice-rocky9 ~]$ 
```

## Get logs from current boot
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl -b
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Linux version 5.14.0-503.35.1.el9_5.x86_64 (mockbuild@iad1-prod-build001.bld.e>
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: The list of certified hardware and cloud instances for Enterprise Linux 9 can >
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.14.0-503.35.1.el9_5.x86_64 root=>
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-provided physical RAM map:
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] ACPI data
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: NX (Execute Disable) protection: active
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: APIC: Static calls initialized
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: SMBIOS 2.5 present.
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
```

## Get logs from past boots
```shell
vagrant@practice-rocky9 ~]$ sudo journalctl --list-boots
IDX BOOT ID                          FIRST ENTRY                 LAST ENTRY                 
 -1 ee1f97d3c1924b0da9bc7db2223faec3 Fri 2025-04-18 09:54:58 IST Fri 2025-04-18 09:55:50 IST
  0 dbe7725896094acfac33095b5bfa5ab5 Fri 2025-04-18 09:55:57 IST Fri 2025-04-18 10:23:03 IST
[vagrant@practice-rocky9 ~]$ sudo journalctl -b -1 |head
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: Linux version 5.14.0-503.35.1.el9_5.x86_64 (mockbuild@iad1-prod-build001.bld.equ.rockylinux.org) (gcc (GCC) 11.5.0 20240719 (Red Hat 11.5.0-5), GNU ld version 2.35.2-54.el9) #1 SMP PREEMPT_DYNAMIC Thu Apr 3 12:12:16 UTC 2025
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: The list of certified hardware and cloud instances for Enterprise Linux 9 can be viewed at the Red Hat Ecosystem Catalog, https://catalog.redhat.com.
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.14.0-503.35.1.el9_5.x86_64 root=UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-provided physical RAM map:
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] ACPI data
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[vagrant@practice-rocky9 ~]$ 
```

## View the logs from the specified time window
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl --since "2025-04-18 10:00:00"| head
Apr 18 10:00:03 practice-rocky9.near2me.biz systemd[1]: Starting system activity accounting tool...
Apr 18 10:00:03 practice-rocky9.near2me.biz systemd[1]: sysstat-collect.service: Deactivated successfully.
Apr 18 10:00:03 practice-rocky9.near2me.biz systemd[1]: Finished system activity accounting tool.
Apr 18 10:02:22 practice-rocky9.near2me.biz systemd[1426]: Created slice User Background Tasks Slice.
Apr 18 10:02:22 practice-rocky9.near2me.biz systemd[1426]: Starting Cleanup of User's Temporary Files and Directories...
Apr 18 10:02:22 practice-rocky9.near2me.biz systemd[1426]: Finished Cleanup of User's Temporary Files and Directories.
Apr 18 10:07:34 practice-rocky9.near2me.biz sudo[1513]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/ls /boot/efi/
Apr 18 10:07:34 practice-rocky9.near2me.biz sudo[1513]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 10:07:34 practice-rocky9.near2me.biz sudo[1513]: pam_unix(sudo:session): session closed for user root
Apr 18 10:07:36 practice-rocky9.near2me.biz sudo[1519]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/ls /boot/efi/E
[vagrant@practice-rocky9 ~]$ 
```

## View the logs upto specified time stamp
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl --until "2025-04-18 09:59:00" |head
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: Linux version 5.14.0-503.35.1.el9_5.x86_64 (mockbuild@iad1-prod-build001.bld.equ.rockylinux.org) (gcc (GCC) 11.5.0 20240719 (Red Hat 11.5.0-5), GNU ld version 2.35.2-54.el9) #1 SMP PREEMPT_DYNAMIC Thu Apr 3 12:12:16 UTC 2025
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: The list of certified hardware and cloud instances for Enterprise Linux 9 can be viewed at the Red Hat Ecosystem Catalog, https://catalog.redhat.com.
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.14.0-503.35.1.el9_5.x86_64 root=UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-provided physical RAM map:
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] ACPI data
Apr 18 09:54:58 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[vagrant@practice-rocky9 ~]$ sudo journalctl --until "2025-04-18 09:59:00" |tail
Apr 18 09:57:19 practice-rocky9.near2me.biz sudo[1463]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/journalctl -u kdump
Apr 18 09:57:19 practice-rocky9.near2me.biz sudo[1463]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 09:57:19 practice-rocky9.near2me.biz sudo[1463]: pam_unix(sudo:session): session closed for user root
Apr 18 09:57:26 practice-rocky9.near2me.biz sudo[1467]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/journalctl -b -u kdump
Apr 18 09:57:26 practice-rocky9.near2me.biz sudo[1467]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 09:57:26 practice-rocky9.near2me.biz sudo[1467]: pam_unix(sudo:session): session closed for user root
Apr 18 09:57:28 practice-rocky9.near2me.biz systemd[1]: systemd-hostnamed.service: Deactivated successfully.
Apr 18 09:57:42 practice-rocky9.near2me.biz sudo[1475]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/systemd-analyze blame
Apr 18 09:57:42 practice-rocky9.near2me.biz sudo[1475]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 09:57:54 practice-rocky9.near2me.biz sudo[1475]: pam_unix(sudo:session): session closed for user root
[vagrant@practice-rocky9 ~]$ 
```

## Logs between 2 time window
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl --since "2025-04-18 09:55:00" --until "2025-04-18 09:59:00" |head
Apr 18 09:55:00 practice-rocky9.near2me.biz systemd[1]: Reached target Initrd Root Device.
Apr 18 09:55:00 practice-rocky9.near2me.biz kernel: e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 08:00:27:fc:e9:96
Apr 18 09:55:00 practice-rocky9.near2me.biz kernel: e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
Apr 18 09:55:00 practice-rocky9.near2me.biz kernel: e1000 0000:00:08.0 eth1: (PCI:33MHz:32-bit) 08:00:27:7f:92:64
Apr 18 09:55:00 practice-rocky9.near2me.biz kernel: e1000 0000:00:08.0 eth1: Intel(R) PRO/1000 Network Connection
Apr 18 09:55:00 practice-rocky9.near2me.biz systemd-udevd[331]: Network interface NamePolicy= disabled on kernel command line.
Apr 18 09:55:00 practice-rocky9.near2me.biz systemd-udevd[334]: Network interface NamePolicy= disabled on kernel command line.
Apr 18 09:55:00 practice-rocky9.near2me.biz systemd[1]: Finished dracut initqueue hook.
Apr 18 09:55:00 practice-rocky9.near2me.biz systemd[1]: Reached target Preparation for Remote File Systems.
Apr 18 09:55:00 practice-rocky9.near2me.biz systemd[1]: Reached target Remote File Systems.
[vagrant@practice-rocky9 ~]$ sudo journalctl --since "2025-04-18 09:55:00" --until "2025-04-18 09:59:00" |tail
Apr 18 09:57:19 practice-rocky9.near2me.biz sudo[1463]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/journalctl -u kdump
Apr 18 09:57:19 practice-rocky9.near2me.biz sudo[1463]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 09:57:19 practice-rocky9.near2me.biz sudo[1463]: pam_unix(sudo:session): session closed for user root
Apr 18 09:57:26 practice-rocky9.near2me.biz sudo[1467]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/journalctl -b -u kdump
Apr 18 09:57:26 practice-rocky9.near2me.biz sudo[1467]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 09:57:26 practice-rocky9.near2me.biz sudo[1467]: pam_unix(sudo:session): session closed for user root
Apr 18 09:57:28 practice-rocky9.near2me.biz systemd[1]: systemd-hostnamed.service: Deactivated successfully.
Apr 18 09:57:42 practice-rocky9.near2me.biz sudo[1475]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/systemd-analyze blame
Apr 18 09:57:42 practice-rocky9.near2me.biz sudo[1475]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 09:57:54 practice-rocky9.near2me.biz sudo[1475]: pam_unix(sudo:session): session closed for user root
[vagrant@practice-rocky9 ~]$
```

## Only view logs for the particular service
```shell
# Logs from all boot
[vagrant@practice-rocky9 ~]$ sudo journalctl -u httpd
Apr 18 09:55:04 practice-rocky9.near2me.biz systemd[1]: Starting The Apache HTTP Server...
Apr 18 09:55:04 practice-rocky9.near2me.biz httpd[621]: Server configured, listening on: port 80
Apr 18 09:55:04 practice-rocky9.near2me.biz systemd[1]: Started The Apache HTTP Server.
Apr 18 09:55:49 practice-rocky9.near2me.biz systemd[1]: Stopping The Apache HTTP Server...
Apr 18 09:55:50 practice-rocky9.near2me.biz systemd[1]: httpd.service: Deactivated successfully.
Apr 18 09:55:50 practice-rocky9.near2me.biz systemd[1]: Stopped The Apache HTTP Server.
-- Boot dbe7725896094acfac33095b5bfa5ab5 --
Apr 18 09:56:02 practice-rocky9.near2me.biz systemd[1]: Starting The Apache HTTP Server...
Apr 18 09:56:02 practice-rocky9.near2me.biz httpd[659]: Server configured, listening on: port 80
Apr 18 09:56:02 practice-rocky9.near2me.biz systemd[1]: Started The Apache HTTP Server.
Apr 18 10:14:36 practice-rocky9.near2me.biz systemd[1]: Stopping The Apache HTTP Server...
Apr 18 10:14:37 practice-rocky9.near2me.biz systemd[1]: httpd.service: Deactivated successfully.
Apr 18 10:14:37 practice-rocky9.near2me.biz systemd[1]: Stopped The Apache HTTP Server.
Apr 18 10:14:37 practice-rocky9.near2me.biz systemd[1]: httpd.service: Consumed 1.205s CPU time.

# Logs from current boot
[vagrant@practice-rocky9 ~]$ sudo journalctl -b -u httpd
Apr 18 09:56:02 practice-rocky9.near2me.biz systemd[1]: Starting The Apache HTTP Server...
Apr 18 09:56:02 practice-rocky9.near2me.biz httpd[659]: Server configured, listening on: port 80
Apr 18 09:56:02 practice-rocky9.near2me.biz systemd[1]: Started The Apache HTTP Server.
Apr 18 10:14:36 practice-rocky9.near2me.biz systemd[1]: Stopping The Apache HTTP Server...
Apr 18 10:14:37 practice-rocky9.near2me.biz systemd[1]: httpd.service: Deactivated successfully.
Apr 18 10:14:37 practice-rocky9.near2me.biz systemd[1]: Stopped The Apache HTTP Server.
Apr 18 10:14:37 practice-rocky9.near2me.biz systemd[1]: httpd.service: Consumed 1.205s CPU time.
[vagrant@practice-rocky9 ~]$ 
```

## Get log entry for particular pid
```shell
[vagrant@practice-rocky9 ~]$ pgrep sshd
1422
1435
[vagrant@practice-rocky9 ~]$ sudo journalctl _PID=1435
-- No entries --
[vagrant@practice-rocky9 ~]$ sudo journalctl _PID=1422
Apr 18 09:56:58 practice-rocky9.near2me.biz sshd[1422]: Accepted publickey for vagrant from 192.168.29.229 port 52830 ssh2: ED2551>
Apr 18 09:56:58 practice-rocky9.near2me.biz sshd[1422]: pam_unix(sshd:session): session opened for user vagrant(uid=1000) by (uid=>
[vagrant@practice-rocky9 ~]$
```

## Display only kernel message like similar to dmesg
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl -k |head
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Linux version 5.14.0-503.35.1.el9_5.x86_64 (mockbuild@iad1-prod-build001.bld.equ.rockylinux.org) (gcc (GCC) 11.5.0 20240719 (Red Hat 11.5.0-5), GNU ld version 2.35.2-54.el9) #1 SMP PREEMPT_DYNAMIC Thu Apr 3 12:12:16 UTC 2025
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: The list of certified hardware and cloud instances for Enterprise Linux 9 can be viewed at the Red Hat Ecosystem Catalog, https://catalog.redhat.com.
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Command line: BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.14.0-503.35.1.el9_5.x86_64 root=UUID=fdc49b1f-324f-4379-9f52-ebee468ee57a ro no_timer_check console=tty0 console=ttyS0,115200n8 net.ifnames=0 biosdevname=0 elevator=noop crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-provided physical RAM map:
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x000000007fff0000-0x000000007fffffff] ACPI data
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[vagrant@practice-rocky9 ~]$ 
```

## Get logs by priority
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl -p emerg -b
-- No entries --
[vagrant@practice-rocky9 ~]$ sudo journalctl -p alert -b
-- No entries --
[vagrant@practice-rocky9 ~]$ sudo journalctl -p crit -b
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Warning: Deprecated Hardware is detected: x86_64-v2:GenuineIntel:Intel(R) Core>
Apr 18 09:55:58 practice-rocky9.near2me.biz kernel: Warning: Unmaintained driver is detected: e1000
Apr 18 09:55:58 practice-rocky9.near2me.biz kernel: Warning: Unmaintained driver is detected: e1000
...skipping...
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Warning: Deprecated Hardware is detected: x86_64-v2:GenuineIntel:Intel(R) Core>
Apr 18 09:55:58 practice-rocky9.near2me.biz kernel: Warning: Unmaintained driver is detected: e1000
Apr 18 09:55:58 practice-rocky9.near2me.biz kernel: Warning: Unmaintained driver is detected: e1000
[vagrant@practice-rocky9 ~]$ sudo journalctl -p err -b
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: Warning: Deprecated Hardware is detected: x86_64-v2:GenuineIntel:Intel(R) Core>
Apr 18 09:55:57 practice-rocky9.near2me.biz kernel: RETBleed: WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed att>
Apr 18 09:55:57 practice-rocky9.near2me.biz systemd[1]: Invalid DMI field header.
Apr 18 09:55:58 practice-rocky9.near2me.biz kernel: Warning: Unmaintained driver is detected: e1000
Apr 18 09:55:58 practice-rocky9.near2me.biz kernel: Warning: Unmaintained driver is detected: e1000
Apr 18 09:56:00 practice-rocky9.near2me.biz systemd[1]: Invalid DMI field header.
Apr 18 09:56:01 practice-rocky9.near2me.biz systemd-udevd[495]: sda: /usr/lib/udev/rules.d/40-elevator.rules:18 Failed to write AT>
Apr 18 09:56:04 practice-rocky9.near2me.biz systemd[1]: Failed to start vboxadd.service.
Apr 18 09:56:04 practice-rocky9.near2me.biz systemd[1]: Failed to start vboxadd-service.service.
Apr 18 09:56:06 practice-rocky9.near2me.biz setroubleshoot[1348]: SELinux is preventing /usr/bin/bash from using the dac_read_sear>
Apr 18 09:56:06 practice-rocky9.near2me.biz setroubleshoot[1348]: failed to retrieve rpm info for path '/etc/sysconfig/network-scr>
Apr 18 09:56:06 practice-rocky9.near2me.biz setroubleshoot[1348]: SELinux is preventing /usr/bin/bash from open access on the file>
Apr 18 09:56:06 practice-rocky9.near2me.biz setroubleshoot[1348]: SELinux is preventing /usr/sbin/kexec from read access on the fi>
Apr 18 10:14:36 practice-rocky9.near2me.biz auditd[548]: plugin /usr/sbin/sedispatch terminated unexpectedly
Apr 18 10:14:38 practice-rocky9.near2me.biz systemd[1667]: rescue.service: Failed to set up standard input: Input/output error
Apr 18 10:14:38 practice-rocky9.near2me.biz systemd[1667]: rescue.service: Failed at step STDIN spawning /usr/bin/plymouth: Input/>
Apr 18 10:14:38 practice-rocky9.near2me.biz systemd[1681]: rescue.service: Failed to set up standard input: Input/output error
Apr 18 10:14:38 practice-rocky9.near2me.biz systemd[1681]: rescue.service: Failed at step STDIN spawning /usr/lib/systemd/systemd->
[vagrant@practice-rocky9 ~]$
```

## Print logs without pager
```shell
journalctl --no-pager
```

## Just like `tail -10`
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl -n 10
Apr 18 10:44:54 practice-rocky9.near2me.biz kernel: audit: type=1106 audit(1744953294.793:587): pid=1949 uid=1000 auid=1000 ses=1 >
Apr 18 10:44:54 practice-rocky9.near2me.biz kernel: audit: type=1104 audit(1744953294.793:588): pid=1949 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:41 practice-rocky9.near2me.biz kernel: audit: type=1101 audit(1744953341.663:589): pid=1953 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:41 practice-rocky9.near2me.biz kernel: audit: type=1123 audit(1744953341.663:590): pid=1953 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:45 practice-rocky9.near2me.biz sudo[1955]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/journa>
Apr 18 10:45:45 practice-rocky9.near2me.biz kernel: audit: type=1101 audit(1744953345.445:591): pid=1955 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:45 practice-rocky9.near2me.biz kernel: audit: type=1123 audit(1744953345.445:592): pid=1955 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:45 practice-rocky9.near2me.biz kernel: audit: type=1110 audit(1744953345.445:593): pid=1955 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:45 practice-rocky9.near2me.biz kernel: audit: type=1105 audit(1744953345.468:594): pid=1955 uid=1000 auid=1000 ses=1 >
Apr 18 10:45:45 practice-rocky9.near2me.biz sudo[1955]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid>
[vagrant@practice-rocky9 ~]$ 
```

## Just like `tail -f`
```shell
[vagrant@practice-rocky9 ~]$ sudo journalctl -f
Apr 18 10:45:45 practice-rocky9.near2me.biz sudo[1955]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 10:45:47 practice-rocky9.near2me.biz sudo[1955]: pam_unix(sudo:session): session closed for user root
Apr 18 10:45:47 practice-rocky9.near2me.biz kernel: audit: type=1106 audit(1744953347.293:595): pid=1955 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
Apr 18 10:45:47 practice-rocky9.near2me.biz kernel: audit: type=1104 audit(1744953347.297:596): pid=1955 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
Apr 18 10:46:16 practice-rocky9.near2me.biz kernel: audit: type=1101 audit(1744953376.883:597): pid=1959 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
Apr 18 10:46:16 practice-rocky9.near2me.biz kernel: audit: type=1123 audit(1744953376.884:598): pid=1959 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=6A6F75726E616C63746C202D66 exe="/usr/bin/sudo" terminal=pts/0 res=success'
Apr 18 10:46:16 practice-rocky9.near2me.biz sudo[1959]:  vagrant : TTY=pts/0 ; PWD=/home/vagrant ; USER=root ; COMMAND=/bin/journalctl -f
Apr 18 10:46:16 practice-rocky9.near2me.biz kernel: audit: type=1110 audit(1744953376.885:599): pid=1959 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
Apr 18 10:46:16 practice-rocky9.near2me.biz sudo[1959]: pam_unix(sudo:session): session opened for user root(uid=0) by vagrant(uid=1000)
Apr 18 10:46:16 practice-rocky9.near2me.biz kernel: audit: type=1105 audit(1744953376.889:600): pid=1959 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
```
