# Restricting a Package to a Fixed Version Number with yum

## Method#1
yum-versionlock is a Yum plugin that takes a set of name/versions for packages and excludes all other versions of those packages (including optionally following obsoletes). This allows you to protect packages from being updated by newer versions. The plugin provides a command "versionlock" which allows you to view and edit the list of locked packages easily.

## Install versionlock plugins
### On rhel7
```shell
yum install yum-plugin-versionlock
```

### On rhel8 and 9
```shell
dnf install python3-dnf-plugin-versionlock
```

## Lock the package version
```shell
yum versionlock bash*
```

## List the locked packages
```shell
yum versionlock list
```

## Clear all packages from versionlock
```shell
yum versionlock clear
```

## Delete the particular package from versionlock
```shell
yum versionlock delete bash*
```


## Method#2
Update `exclude` variable on /etc/yum.conf or /etc/dnf/dnf.conf to exclude the package from update. This will restrict the mentioned packages on listing as well.

```shell
vagrant@practice-rocky9 ~]$ yum list kernel
Last metadata expiration check: 0:15:36 ago on Wed 16 Apr 2025 01:22:56 PM UTC.
Installed Packages
kernel.x86_64                               5.14.0-362.8.1.el9_3                                @anaconda
Available Packages
kernel.x86_64                               5.14.0-503.35.1.el9_5                               baseos   
[vagrant@practice-rocky9 ~]$ echo "exclude=kernel" |sudo tee -a /etc/yum.conf
exclude=kernel
[vagrant@practice-rocky9 ~]$ echo "exclude=kernel" |sudo tee -a /etc/dnf/dnf.conf
exclude=kernel
[vagrant@practice-rocky9 ~]$ cat /etc/yum.conf
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True
skip_if_unavailable=False
exclude=kernel
[vagrant@practice-rocky9 ~]$ cat /etc/dnf/dnf.conf
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True
skip_if_unavailable=False
exclude=kernel
[vagrant@practice-rocky9 ~]$ yum list kernel
Last metadata expiration check: 0:16:19 ago on Wed 16 Apr 2025 01:22:56 PM UTC.
Error: No matching Packages to list
[vagrant@practice-rocky9 ~]$ 
```