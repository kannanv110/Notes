# How to fix yum stale lock?

 - Take backup copy of `/var/lib/rpm/` before you start. 
 - Best option to clear the stale lock file is to reboot the system. At the time of boot there will be no process using the lock file and the system will automatically clear the lock file under `/var/lib/rpm/__db*`.
 - If you can't reboot the system then make sure no rpm, yum or dnf command running on the system. Check for any files under `/var/lib/rpm/__db*` open using `lsof` command.
 - If you are sure that nothing hold the lock then go ahead to delete the files `/var/lib/yum/__db*`.
 
