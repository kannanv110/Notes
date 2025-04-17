Linux patching interview questions often focus on understanding the process, tools, and best practices for applying updates and security patches to a Linux system. Key areas include identifying vulnerability types, applying updates using package managers, and troubleshooting post-patching issues. [1]  
Common Interview Questions and Answers: [1]  
1.  What is the purpose of patching a Linux system? [1]  

• Answer: Patching a Linux system applies security updates and bug fixes to address vulnerabilities, enhance system stability, and improve overall performance. [1]  

2.  How do you identify which packages need to be updated on a Linux system? [1, 2]  

• Answer: Use package managers like yum, apt, or dnf to check for available updates and identify systems requiring updates. [1, 2]  
```shell
[vagrant@practice-rocky9 ~]$ sudo dnf updateinfo
Last metadata expiration check: 0:37:22 ago on Wed 16 Apr 2025 09:16:08 AM UTC.
Updates Information Summary: available
    25 Security notice(s)
         6 Important Security notice(s)
        18 Moderate Security notice(s)
         1 Low Security notice(s)
    34 Bugfix notice(s)
     2 Enhancement notice(s)
[vagrant@practice-rocky9 ~]$ 
```

```shell
vagrant@practice-rocky9 ~]$ sudo yum check-update 
Last metadata expiration check: 0:30:14 ago on Wed 16 Apr 2025 09:16:08 AM UTC.

NetworkManager.x86_64                             1:1.48.10-8.el9_5                             baseos   
NetworkManager-libnm.x86_64                       1:1.48.10-8.el9_5                             baseos   
NetworkManager-team.x86_64                        1:1.48.10-8.el9_5                             baseos   
NetworkManager-tui.x86_64                         1:1.48.10-8.el9_5                             baseos   
acl.x86_64                                        2.3.1-4.el9                                   baseos   
alternatives.x86_64                               1.24-1.el9_5.1                                baseos   
audit.x86_64                                      3.1.5-1.el9                                   baseos   
audit-libs.x86_64                                 3.1.5-1.el9                                   baseos   
avahi-libs.x86_64                                 0.8-21.el9                                    baseos   
basesystem.noarch                                 11-13.el9.0.1                                 baseos   
bash-completion.noarch                            1:2.11-5.el9                                  baseos   
binutils.x86_64                                   2.35.2-54.el9                                 baseos   
```
```shell
vagrant@technear2me:~$ sudo apt list --upgradable
Listing... Done
apparmor/jammy-updates,jammy-security 3.0.4-2ubuntu2.4 amd64 [upgradable from: 3.0.4-2ubuntu2.2]
apport/jammy-updates 2.20.11-0ubuntu82.6 all [upgradable from: 2.20.11-0ubuntu82.5]
apt-utils/jammy-updates 2.4.13 amd64 [upgradable from: 2.4.10]
apt/jammy-updates 2.4.13 amd64 [upgradable from: 2.4.10]
base-files/jammy-updates 12ubuntu4.7 amd64 [upgradable from: 12ubuntu4.4]
bash/jammy-updates,jammy-security 5.1-6ubuntu1.1 amd64 [upgradable from: 5.1-6ubuntu1]
bind9-dnsutils/jammy-updates,jammy-security 1:9.18.30-0ubuntu0.22.04.2 amd64 [upgradable from: 1:9.18.12-0ubuntu0.22.04.3]
bind9-host/jammy-updates,jammy-security 1:9.18.30-0ubuntu0.22.04.2 amd64 [upgradable from: 1:9.18.12-0ubuntu0.22.04.3]
bind9-libs/jammy-updates,jammy-security 1:9.18.30-0ubuntu0.22.04.2 amd64 [upgradable from: 1:9.18.12-0ubuntu0.22.04.3]
binutils-common/jammy-updates,jammy-security 2.38-4ubuntu2.8 amd64 [upgradable from: 2.38-4ubuntu2.3]
binutils-x86-64-linux-gnu/jammy-updates,jammy-security 2.38-4ubuntu2.8 amd64 [upgradable from: 2.38-4ubuntu2.3]
```

3.  Describe the process of applying a security patch to a Linux system. [1, 2]  

• Answer: The process typically involves downloading the patch, verifying its integrity, applying it using the appropriate package manager, and rebooting the system (if necessary). [1, 2]  

4.  What tools are used for patching a Linux system? [1, 2]  

• Answer: Package managers (e.g., yum, apt, dnf), security scanners, and vulnerability management tools are used. [1, 2]  

5.  What are the potential impacts of not applying patches? [1]  

• Answer: Not applying patches can leave systems vulnerable to security exploits, lead to instability, and potentially cause data breaches or service outages. [1]  

6.  How do you verify that a patch has been applied successfully? [1, 2]  

• Answer: Verify by checking the version of the updated package using the package manager, examining system logs, and testing functionality to ensure no issues arose. [1, 2]  

7.  What should you do if a patch installation fails or causes issues? [1, 2]  

• Answer: First, examine system logs, research known issues with the patch, and consider rolling back to a previous version if necessary. [1, 2]  

8.  How do you handle situations where a patch might break a specific application or service? [1, 2]  

• Answer: Prioritize critical services, research the patch's impact, and consider delaying the update, using a testing environment, or using workarounds until a stable patch is available. [1, 2]  

9.  What are the best practices for patching a Linux system? [1, 2]  

• Answer: Use a systematic approach, automate patching when possible, implement a patching schedule, and test patches in a non-production environment before deploying them to production systems. [1, 2]  

10. How do you handle patching on a production server without downtime? [1]  

• Answer: Use techniques like hotfixes, rolling updates, and patching services that allow applications to continue running during the update process. [1]  

11. Explain the differences between security patches and kernel updates. [1]  

• Answer: Security patches address specific vulnerabilities, while kernel updates often include bug fixes, performance improvements, and new features. [1]  

Generative AI is experimental.
12. How to fix rpm Stale lock file?

• Answer: Take backup copy of `/var/lib/rpm/` before you start. Best option to clear the stale lock file is to reboot the system. At the time of boot there will be no process using the lock file and the system will automatically clear the lock file under `/var/lib/rpm/__db*`. If you can't reboot the system then make sure no rpm, yum or dnf command running on the system. Check for any files under `/var/lib/rpm/__db*` open using `lsof` command. If you are sure that nothing hold the lock then go ahead to delete the files `/var/lib/yum/__db*`.

13. How to fix the corrupted rpm db other than rhel9?

• Answer: Take backup of `/var/lib/rpm/`. Remove files `__db*`. 
[1] https://testlify.com/interview-questions-for-linux-system-administrator/[2] https://www.ambitionbox.com/profiles/linux-administrator/interview-questions

14. How to fix the corrupted rpm db on rhel9?

• Answer: In rhel9 the rpm database stored on sqlite3. rpmdb is stored on `/var/lib/rpm/rpmdb.sqlite`. This is how the rpm db get update. Sqlite implement “atomic commit and rollback”. Its maintain 2 files .wal and .shm. WAL stands for Write Ahead Logging.

**Steps per event**

**MODIFY**

A change was written to the WAL file (rpmdb.sqlite-wal). The original database (rpmdb.sqlite) has not changed yet.

**COMMIT**

A special record indicating a commit is added to the WAL file.

**CHECKPOINT**

WAL file transaction moves into the original database.

**Verify the DB**
```shell
rpm --verifydb && echo "DB Ok" || echo "DB Corrupted"
```

**Recover corrupted database**
```shell
rpmdb --rebuilddb

or

rpm --rebuilddb
```

