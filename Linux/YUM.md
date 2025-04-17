# YUM(Yellowdog Updater, Modified)

## YUM Repos
### Sample repo config file
```shell
[vagrant@practice-rocky9 packages]$ cat /etc/yum.repos.d/rocky.repo 
# rocky.repo
#
# The mirrorlist system uses the connecting IP address of the client and the
# update status of each mirror to pick current mirrors that are geographically
# close to the client.  You should use this for Rocky updates unless you are
# manually picking other mirrors.
#
# If the mirrorlist does not work for you, you can try the commented out
# baseurl line instead.

[baseos]
name=Rocky Linux $releasever - BaseOS
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever$rltype
#baseurl=http://dl.rockylinux.org/$contentdir/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
countme=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-9

[baseos-debug]
name=Rocky Linux $releasever - BaseOS - Debug
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever-debug$rltype
#baseurl=http://dl.rockylinux.org/$contentdir/$releasever/BaseOS/$basearch/debug/tree/
gpgcheck=1
enabled=0
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-9

[baseos-source]
name=Rocky Linux $releasever - BaseOS - Source
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=BaseOS-$releasever-source$rltype
#baseurl=http://dl.rockylinux.org/$contentdir/$releasever/BaseOS/source/tree/
gpgcheck=1
enabled=0
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-9

[appstream]
name=Rocky Linux $releasever - AppStream
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever$rltype
#baseurl=http://dl.rockylinux.org/$contentdir/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
countme=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Rocky-9
```

### List Enabled Repos
```shell
[vagrant@practice-rocky9 packages]$ yum repolist
repo id                                      repo name
appstream                                    Rocky Linux 9 - AppStream
baseos                                       Rocky Linux 9 - BaseOS
extras                                       Rocky Linux 9 - Extras
[vagrant@practice-rocky9 packages]$
```

### Display repo information
```shell
[vagrant@practice-rocky9 packages]$ yum repoinfo appstream
Last metadata expiration check: 0:32:17 ago on Tue 15 Apr 2025 05:54:16 AM UTC.
Repo-id            : appstream
Repo-name          : Rocky Linux 9 - AppStream
Repo-status        : enabled
Repo-revision      : 1744593162
Repo-updated       : Mon 14 Apr 2025 01:12:42 AM UTC
Repo-pkgs          : 5,998
Repo-available-pkgs: 5,749
Repo-size          : 9.4 G
Repo-mirrors       : https://mirrors.rockylinux.org/mirrorlist?arch=x86_64&repo=AppStream-9
Repo-baseurl       : https://rocky-linux-asia-south1.production.gcp.mirrors.ctrliq.cloud/pub/rocky//9.5/AppStream/x86_64/os/
                   : (38 more)
Repo-expire        : 21,600 second(s) (last: Tue 15 Apr 2025 05:54:10 AM UTC)
Repo-filename      : /etc/yum.repos.d/rocky.repo
Total packages: 5,998
[vagrant@practice-rocky9 packages]$
```

### List both Enabled/Disabled Repos
```shell
[vagrant@practice-rocky9 packages]$ sudo yum repolist all
repo id                 repo name                                                                status
appstream               Rocky Linux 9 - AppStream                                                enabled
appstream-debug         Rocky Linux 9 - AppStream - Debug                                        disabled
appstream-source        Rocky Linux 9 - AppStream - Source                                       disabled
baseos                  Rocky Linux 9 - BaseOS                                                   enabled
baseos-debug            Rocky Linux 9 - BaseOS - Debug                                           disabled
baseos-source           Rocky Linux 9 - BaseOS - Source                                          disabled
crb                     Rocky Linux 9 - CRB                                                      disabled
crb-debug               Rocky Linux 9 - CRB - Debug                                              disabled
crb-source              Rocky Linux 9 - CRB - Source                                             disabled
devel                   Rocky Linux 9 - Devel WARNING! FOR BUILDROOT ONLY DO NOT LEAVE ENABLED   disabled
devel-debug             Rocky Linux 9 - Devel Debug WARNING! FOR BUILDROOT ONLY DO NOT LEAVE ENA disabled
devel-source            Rocky Linux 9 - Devel Source WARNING! FOR BUILDROOT ONLY DO NOT LEAVE EN disabled
extras                  Rocky Linux 9 - Extras                                                   enabled
extras-debug            Rocky Linux 9 - Extras Debug                                             disabled
extras-source           Rocky Linux 9 - Extras Source                                            disabled
highavailability        Rocky Linux 9 - High Availability                                        disabled
highavailability-debug  Rocky Linux 9 - High Availability - Debug                                disabled
highavailability-source Rocky Linux 9 - High Availability - Source                               disabled
```
### Enable the repo permanently
```shell
vagrant@practice-rocky9 packages]$ sudo yum repolist all |grep -w "sap "
sap                     Rocky Linux 9 - SAP                             disabled
[vagrant@practice-rocky9 packages]$ sudo yum config-manager --set-enabled sap
[vagrant@practice-rocky9 packages]$ sudo yum repolist all |grep -w "sap "
sap                     Rocky Linux 9 - SAP                             enabled
[vagrant@practice-rocky9 packages]$
```

### Disable the repo permanently
```shell
vagrant@practice-rocky9 packages]$ sudo yum repolist all |grep -w "sap "
sap                     Rocky Linux 9 - SAP                             enabled
[vagrant@practice-rocky9 packages]$ sudo yum config-manager --set-disabled sap
[vagrant@practice-rocky9 packages]$ sudo yum repolist all |grep -w "sap "
sap                     Rocky Linux 9 - SAP                             disabled
[vagrant@practice-rocky9 packages]$
```

### Install the package from particular repo
In the example mirror for appstream repo broken and getting error while installing package. We can mention the repo to install the package.

#### Method#1
```shell
[vagrant@practice-rocky9 packages]$ sudo yum repo-pkgs baseos install zsh
Rocky Linux 9 - BaseOS                                                   1.4 kB/s | 4.1 kB     00:02    
Rocky Linux 9 - AppStream                                                1.9 kB/s | 4.5 kB     00:02    
Rocky Linux 9 - AppStream                                                970 kB/s | 8.6 MB     00:09    
Dependencies resolved.
=========================================================================================================
 Package              Architecture            Version                      Repository               Size
=========================================================================================================
Installing:
 zsh                  x86_64                  5.8-9.el9                    baseos                  2.9 M

Transaction Summary
=========================================================================================================
Install  1 Package

Total download size: 2.9 M
Installed size: 7.6 M
Is this ok [y/N]: n
Operation aborted.
[vagrant@practice-rocky9 packages]$ 
```

#### Method#2
```shell
[vagrant@practice-rocky9 packages]$ sudo yum install zsh
Rocky Linux 9 - AppStream                                                0.0  B/s |   0  B     00:00    
Errors during downloading metadata for repository 'appstream':
  - Curl error (6): Couldn't resolve host name for https://mirro.rockylinux.org/mirrorlist?arch=x86_64&repo=AppStream-9 [Could not resolve host: mirro.rockylinux.org]
Error: Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: Curl error (6): Couldn't resolve host name for https://mirro.rockylinux.org/mirrorlist?arch=x86_64&repo=AppStream-9 [Could not resolve host: mirro.rockylinux.org]

[vagrant@practice-rocky9 packages]$ sudo yum install zsh --repo baseos
Last metadata expiration check: 0:00:31 ago on Tue 15 Apr 2025 06:46:40 AM UTC.
Dependencies resolved.
=========================================================================================================
 Package              Architecture            Version                      Repository               Size
=========================================================================================================
Installing:
 zsh                  x86_64                  5.8-9.el9                    baseos                  2.9 M

Transaction Summary
=========================================================================================================
Install  1 Package

Total download size: 2.9 M
Installed size: 7.6 M
Is this ok [y/N]: N
Operation aborted.
[vagrant@practice-rocky9 packages]$
```

## YUM List
### List installed packages
```shell
vagrant@practice-rocky9 packages]$ yum list installed |more
Installed Packages
NetworkManager.x86_64                1:1.44.0-3.el9                   @anaconda 
NetworkManager-libnm.x86_64          1:1.44.0-3.el9                   @anaconda 
NetworkManager-team.x86_64           1:1.44.0-3.el9                   @anaconda 
NetworkManager-tui.x86_64            1:1.44.0-3.el9                   @anaconda 
acl.x86_64                           2.3.1-3.el9                      @anaconda 
alternatives.x86_64                  1.24-1.el9                       @anaconda 
audit.x86_64                         3.0.7-104.el9                    @anaconda 
audit-libs.x86_64                    3.0.7-104.el9                    @anaconda 
authselect.x86_64                    1.2.6-2.el9                      @anaconda 
authselect-libs.x86_64               1.2.6-2.el9                      @anaconda 
avahi-libs.x86_64                    0.8-15.el9                       @anaconda 
basesystem.noarch                    11-13.el9                        @anaconda 
bash.x86_64                          5.1.8-6.el9_1                    @anaconda 
bash-completion.noarch               1:2.11-4.el9                     @anaconda 
binutils.x86_64                      2.35.2-42.el9                    @anaconda
```

### List available packages
```shell
[vagrant@practice-rocky9 packages]$ yum list available |more
Rocky Linux 9 - BaseOS                          2.6 kB/s | 4.1 kB     00:01    
Rocky Linux 9 - BaseOS                          584 kB/s | 2.3 MB     00:04    
Rocky Linux 9 - AppStream                       1.2 kB/s | 4.5 kB     00:03    
Rocky Linux 9 - AppStream                       858 kB/s | 8.6 MB     00:10    
Last metadata expiration check: 0:00:01 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
Available Packages
389-ds-base.x86_64                                   2.5.2-8.el9_5                       appstream
389-ds-base-libs.x86_64                              2.5.2-8.el9_5                       appstream
389-ds-base-snmp.x86_64                              2.5.2-8.el9_5                       appstream
Box2D.i686                                           2.4.1-7.el9                         appstream
Box2D.x86_64                                         2.4.1-7.el9                         appstream
CUnit.i686                                           2.1.3-25.el9                        appstream
CUnit.x86_64                                         2.1.3-25.el9                        appstream
HdrHistogram_c.i686                                  0.11.0-6.el9                        appstream
HdrHistogram_c.x86_64                                0.11.0-6.el9                        appstream
Judy.i686                                            1.0.5-28.el9                        appstream
Judy.x86_64                                          1.0.5-28.el9                        appstream
LibRaw.i686                                          0.21.1-1.el9                        appstream
LibRaw.x86_64                                        0.21.1-1.el9                        appstream
ModemManager.x86_64                                  1.20.2-1.el9                        baseos   
```

### List both installed and available packages
```shell
[vagrant@practice-rocky9 packages]$ yum list all |more
Last metadata expiration check: 0:02:50 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
Installed Packages
NetworkManager.x86_64                                1:1.44.0-3.el9                      @anaconda 
NetworkManager-libnm.x86_64                          1:1.44.0-3.el9                      @anaconda 
NetworkManager-team.x86_64                           1:1.44.0-3.el9                      @anaconda 
NetworkManager-tui.x86_64                            1:1.44.0-3.el9                      @anaconda 
acl.x86_64                                           2.3.1-3.el9                         @anaconda 
alternatives.x86_64                                  1.24-1.el9                          @anaconda 
audit.x86_64                                         3.0.7-104.el9                       @anaconda 
audit-libs.x86_64                                    3.0.7-104.el9                       @anaconda 
authselect.x86_64                                    1.2.6-2.el9                         @anaconda 
authselect-libs.x86_64                               1.2.6-2.el9                         @anaconda 
Available Packages
389-ds-base.x86_64                                   2.5.2-8.el9_5                       appstream 
389-ds-base-libs.x86_64                              2.5.2-8.el9_5                       appstream 
389-ds-base-snmp.x86_64                              2.5.2-8.el9_5                       appstream 
Box2D.i686                                           2.4.1-7.el9                         appstream 
Box2D.x86_64                                         2.4.1-7.el9                         appstream 
CUnit.i686                                           2.1.3-25.el9                        appstream 
CUnit.x86_64                                         2.1.3-25.el9                        appstream 
HdrHistogram_c.i686                                  0.11.0-6.el9                        appstream 
HdrHistogram_c.x86_64                                0.11.0-6.el9                        appstream 
Judy.i686                                            1.0.5-28.el9                        appstream 
Judy.x86_64                                          1.0.5-28.el9                        appstream 
LibRaw.i686                                          0.21.1-1.el9                        appstream 
LibRaw.x86_64                                        0.21.1-1.el9                        appstream 
ModemManager.x86_64                                  1.20.2-1.el9                        baseos    
ModemManager-glib.i686                               1.20.2-1.el9                        baseos    
ModemManager-glib.x86_64                             1.20.2-1.el9                        baseos    
NetworkManager.x86_64                                1:1.48.10-8.el9_5                   baseos    
NetworkManager-adsl.x86_64                           1:1.48.10-8.el9_5                   baseos    
NetworkManager-bluetooth.x86_64                      1:1.48.10-8.el9_5                   baseos    
```


## YUM Packages
### List installed and available packages for the given package name
```shell
[vagrant@practice-rocky9 packages]$ yum list bash
Last metadata expiration check: 0:04:46 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
Installed Packages
bash.x86_64                                    5.1.8-6.el9_1                                    @anaconda
Available Packages
bash.x86_64                                    5.1.8-9.el9                                      baseos   
[vagrant@practice-rocky9 packages]$ 
```

### Get information about package
```shell
[vagrant@practice-rocky9 packages]$ yum info bash
Last metadata expiration check: 0:05:20 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
Installed Packages
Name         : bash
Version      : 5.1.8
Release      : 6.el9_1
Architecture : x86_64
Size         : 7.4 M
Source       : bash-5.1.8-6.el9_1.src.rpm
Repository   : @System
From repo    : anaconda
Summary      : The GNU Bourne Again shell
URL          : https://www.gnu.org/software/bash
License      : GPLv3+
Description  : The GNU Bourne Again shell (Bash) is a shell or command language
             : interpreter that is compatible with the Bourne shell (sh). Bash
             : incorporates useful features from the Korn shell (ksh) and the C shell
             : (csh). Most sh scripts can be run by bash without modification.

Available Packages
Name         : bash
Version      : 5.1.8
Release      : 9.el9
Architecture : x86_64
Size         : 1.7 M
Source       : bash-5.1.8-9.el9.src.rpm
Repository   : baseos
Summary      : The GNU Bourne Again shell
URL          : https://www.gnu.org/software/bash
License      : GPLv3+
Description  : The GNU Bourne Again shell (Bash) is a shell or command language
             : interpreter that is compatible with the Bourne shell (sh). Bash
             : incorporates useful features from the Korn shell (ksh) and the C shell
             : (csh). Most sh scripts can be run by bash without modification.

[vagrant@practice-rocky9 packages]$
```

### List dependencies for the package
```shell
[vagrant@practice-rocky9 packages]$ yum deplist kernel
Last metadata expiration check: 0:11:22 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
package: kernel-5.14.0-503.35.1.el9_5.x86_64
  dependency: kernel-core-uname-r = 5.14.0-503.35.1.el9_5.x86_64
   provider: kernel-core-5.14.0-503.35.1.el9_5.x86_64
  dependency: kernel-modules-core-uname-r = 5.14.0-503.35.1.el9_5.x86_64
   provider: kernel-modules-core-5.14.0-503.35.1.el9_5.x86_64
  dependency: kernel-modules-uname-r = 5.14.0-503.35.1.el9_5.x86_64
   provider: kernel-modules-5.14.0-503.35.1.el9_5.x86_64
[vagrant@practice-rocky9 packages]$ yum deplist zsh
Last metadata expiration check: 0:11:28 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
package: zsh-5.8-9.el9.x86_64
  dependency: /bin/sh
   provider: bash-5.1.8-9.el9.x86_64
  dependency: /usr/bin/sh
   provider: bash-5.1.8-9.el9.x86_64
  dependency: coreutils
   provider: coreutils-8.32-36.el9.x86_64
  dependency: grep
   provider: grep-3.6-5.el9.x86_64
  dependency: libc.so.6(GLIBC_2.34)(64bit)
   provider: glibc-2.34-125.el9_5.3.x86_64
  dependency: libgdbm.so.6()(64bit)
   provider: gdbm-libs-1:1.23-1.el9.x86_64
  dependency: libm.so.6()(64bit)
   provider: glibc-2.34-125.el9_5.3.x86_64
  dependency: libm.so.6(GLIBC_2.2.5)(64bit)
   provider: glibc-2.34-125.el9_5.3.x86_64
  dependency: libm.so.6(GLIBC_2.23)(64bit)
   provider: glibc-2.34-125.el9_5.3.x86_64
  dependency: libm.so.6(GLIBC_2.29)(64bit)
   provider: glibc-2.34-125.el9_5.3.x86_64
  dependency: libncursesw.so.6()(64bit)
   provider: ncurses-libs-6.2-10.20210508.el9.x86_64
  dependency: libpcre.so.1()(64bit)
   provider: pcre-8.44-4.el9.x86_64
  dependency: libtinfo.so.6()(64bit)
   provider: ncurses-libs-6.2-10.20210508.el9.x86_64
  dependency: rtld(GNU_HASH)
   provider: glibc-2.34-125.el9_5.3.x86_64
   provider: glibc-2.34-125.el9_5.3.i686
[vagrant@practice-rocky9 packages]$ 
```
### Install the package
```shell
[vagrant@practice-rocky9 packages]$ sudo yum install bash
Last metadata expiration check: 0:09:45 ago on Tue 15 Apr 2025 06:51:07 AM UTC.
Package bash-5.1.8-6.el9_1.x86_64 is already installed.
Dependencies resolved.
=========================================================================================================
 Package              Architecture           Version                        Repository              Size
=========================================================================================================
Upgrading:
 bash                 x86_64                 5.1.8-9.el9                    baseos                 1.7 M

Transaction Summary
=========================================================================================================
Upgrade  1 Package

Total download size: 1.7 M
Is this ok [y/N]: N
Operation aborted.
[vagrant@practice-rocky9 packages]$
```

### Update the package
```shell
[vagrant@practice-rocky9 packages]$ sudo yum update bash
Last metadata expiration check: 0:13:10 ago on Tue 15 Apr 2025 06:51:07 AM UTC.
Dependencies resolved.
=========================================================================================================
 Package              Architecture           Version                        Repository              Size
=========================================================================================================
Upgrading:
 bash                 x86_64                 5.1.8-9.el9                    baseos                 1.7 M

Transaction Summary
=========================================================================================================
Upgrade  1 Package

Total download size: 1.7 M
Is this ok [y/N]: y                                               
Downloading Packages:
bash-5.1.8-9.el9.x86_64.rpm                                              569 kB/s | 1.7 MB     00:02    
---------------------------------------------------------------------------------------------------------
Total                                                                    232 kB/s | 1.7 MB     00:07     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                 1/1 
  Upgrading        : bash-5.1.8-9.el9.x86_64                                                         1/2 
  Running scriptlet: bash-5.1.8-9.el9.x86_64                                                         1/2 
  Cleanup          : bash-5.1.8-6.el9_1.x86_64                                                       2/2 
  Running scriptlet: bash-5.1.8-6.el9_1.x86_64                                                       2/2 
  Verifying        : bash-5.1.8-9.el9.x86_64                                                         1/2 
  Verifying        : bash-5.1.8-6.el9_1.x86_64                                                       2/2 

Upgraded:
  bash-5.1.8-9.el9.x86_64                                                                                

Complete!
[vagrant@practice-rocky9 packages]$
```

### Search for package
```shell
[vagrant@practice-rocky9 packages]$ yum search "Active Directory"
Last metadata expiration check: 0:13:46 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
=================================== Summary Matched: Active Directory ===================================
adcli.x86_64 : Active Directory enrollment
ipa-server-trust-ad.x86_64 : Virtual package to install packages required for Active Directory trusts
[vagrant@practice-rocky9 packages]$ 
```

### Search for the package which provide the given file
```shell
[vagrant@practice-rocky9 packages]$ yum provides */passwd
Last metadata expiration check: 0:16:00 ago on Tue 15 Apr 2025 06:54:13 AM UTC.
bash-completion-1:2.11-4.el9.noarch : Programmable completion for Bash
Repo        : @System
Matched from:
Filename    : /usr/share/bash-completion/completions/passwd

bash-completion-1:2.11-5.el9.noarch : Programmable completion for Bash
Repo        : baseos
Matched from:
Filename    : /usr/share/bash-completion/completions/passwd

freeradius-3.0.21-43.el9_5.x86_64 : High-performance and highly configurable free RADIUS server
Repo        : appstream
Matched from:
Filename    : /etc/raddb/mods-available/passwd
Filename    : /etc/raddb/mods-enabled/passwd

nscd-2.34-125.el9_5.3.x86_64 : A Name Service Caching Daemon (nscd).
Repo        : baseos
Matched from:
Filename    : /var/db/nscd/passwd
Filename    : /var/run/nscd/passwd

passwd-0.80-12.el9.x86_64 : An utility for setting or changing passwords using PAM
Repo        : @System
Matched from:
Filename    : /etc/pam.d/passwd
Filename    : /usr/bin/passwd
Filename    : /usr/share/doc/passwd
Filename    : /usr/share/licenses/passwd

passwd-0.80-12.el9.x86_64 : An utility for setting or changing passwords using PAM
Repo        : baseos
Matched from:
Filename    : /etc/pam.d/passwd
Filename    : /usr/bin/passwd
Filename    : /usr/share/doc/passwd
Filename    : /usr/share/licenses/passwd

rear-2.6-25.el9.x86_64 : Relax-and-Recover is a Linux disaster recovery and system migration tool
Repo        : appstream
Matched from:
Filename    : /usr/share/rear/skel/default/etc/passwd

setup-2.13.7-9.el9.noarch : A set of system configuration and setup files
Repo        : @System
Matched from:
Filename    : /etc/passwd

setup-2.13.7-10.el9.noarch : A set of system configuration and setup files
Repo        : baseos
Matched from:
Filename    : /etc/passwd

sssd-common-2.9.1-4.el9_3.x86_64 : Common files for the SSSD
Repo        : @System
Matched from:
Filename    : /var/lib/sss/mc/passwd

sssd-common-2.9.5-4.el9_5.4.x86_64 : Common files for the SSSD
Repo        : baseos
Matched from:
Filename    : /var/lib/sss/mc/passwd

[vagrant@practice-rocky9 packages]$
```

### Install local rpm package
```shell
yum localinstall abc-1-1.x86_64.rpm
```

### Downgrade the package
```shell
[vagrant@practice-rocky9 packages]$ sudo yum downgrade bash
Last metadata expiration check: 0:29:22 ago on Tue 15 Apr 2025 06:51:07 AM UTC.
Package bash of lowest version already installed, cannot downgrade it.
Dependencies resolved.
Nothing to do.
Complete!
[vagrant@practice-rocky9 packages]$ 
```

### reinstall the package
```shell
vagrant@practice-rocky9 packages]$ sudo yum reinstall bash
Last metadata expiration check: 0:26:08 ago on Tue 15 Apr 2025 06:51:07 AM UTC.
Dependencies resolved.
=========================================================================================================
 Package              Architecture           Version                        Repository              Size
=========================================================================================================
Reinstalling:
 bash                 x86_64                 5.1.8-9.el9                    baseos                 1.7 M

Transaction Summary
=========================================================================================================

Total download size: 1.7 M
Installed size: 7.4 M
Is this ok [y/N]: y
Downloading Packages:
bash-5.1.8-9.el9.x86_64.rpm                                              979 kB/s | 1.7 MB     00:01    
---------------------------------------------------------------------------------------------------------
Total                                                                    622 kB/s | 1.7 MB     00:02     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                 1/1 
  Reinstalling     : bash-5.1.8-9.el9.x86_64                                                         1/2 
  Running scriptlet: bash-5.1.8-9.el9.x86_64                                                         1/2 
  Cleanup          : bash-5.1.8-9.el9.x86_64                                                         2/2 
  Running scriptlet: bash-5.1.8-9.el9.x86_64                                                         2/2 
  Verifying        : bash-5.1.8-9.el9.x86_64                                                         1/2 
  Verifying        : bash-5.1.8-9.el9.x86_64                                                         2/2 

Reinstalled:
  bash-5.1.8-9.el9.x86_64                                                                                

Complete!
[vagrant@practice-rocky9 packages]$ 
```

### swap the package
```shell
[vagrant@practice-rocky9 packages]$ sudo yum swap ftp lftp
Last metadata expiration check: 0:31:12 ago on Tue 15 Apr 2025 06:51:07 AM UTC.
Dependencies resolved.
=========================================================================================================
 Package             Architecture          Version                       Repository                 Size
=========================================================================================================
Installing:
 lftp                x86_64                4.9.2-4.el9                   appstream                 912 k
Removing:
 ftp                 x86_64                0.17-89.el9                   @appstream                112 k

Transaction Summary
=========================================================================================================
Install  1 Package
Remove   1 Package

Total download size: 912 k
Is this ok [y/N]: y
Downloading Packages:
lftp-4.9.2-4.el9.x86_64.rpm                                              557 kB/s | 912 kB     00:01    
---------------------------------------------------------------------------------------------------------
Total                                                                    349 kB/s | 912 kB     00:02     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                 1/1 
  Installing       : lftp-4.9.2-4.el9.x86_64                                                         1/2 
  Erasing          : ftp-0.17-89.el9.x86_64                                                          2/2 
  Running scriptlet: ftp-0.17-89.el9.x86_64                                                          2/2 
  Verifying        : lftp-4.9.2-4.el9.x86_64                                                         1/2 
  Verifying        : ftp-0.17-89.el9.x86_64                                                          2/2 

Installed:
  lftp-4.9.2-4.el9.x86_64                                                                                
Removed:
  ftp-0.17-89.el9.x86_64                                                                                 

Complete!
[vagrant@practice-rocky9 packages]$
```

### Erase the package
```shell
[vagrant@practice-rocky9 packages]$ sudo yum remove lftp
Dependencies resolved.
=========================================================================================================
 Package             Architecture          Version                       Repository                 Size
=========================================================================================================
Removing:
 lftp                x86_64                4.9.2-4.el9                   @appstream                3.0 M

Transaction Summary
=========================================================================================================
Remove  1 Package

Freed space: 3.0 M
Is this ok [y/N]: y
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                 1/1 
  Erasing          : lftp-4.9.2-4.el9.x86_64                                                         1/1 
  Running scriptlet: lftp-4.9.2-4.el9.x86_64                                                         1/1 
  Verifying        : lftp-4.9.2-4.el9.x86_64                                                         1/1 

Removed:
  lftp-4.9.2-4.el9.x86_64                                                                                

Complete!
[vagrant@practice-rocky9 packages]$ 
```
