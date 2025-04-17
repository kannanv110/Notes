# How to fix corrupted rpm DB?

## In rhel9
In rhel9 the rpm database stored on sqlite3. rpmdb is stored on `/var/lib/rpm/rpmdb.sqlite`. This is how the rpm db get update. Sqlite implement “atomic commit and rollback”. Its maintain 2 files .wal and .shm. WAL stands for Write Ahead Logging.

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

## Other than rhel9
### Step#1
- Take backup of /var/lib/rpm
- Remove lock file from /var/lib/rpm/
```shell
tar cvf /tmp/rpm.tar /var/lib/rpm
rm -f /var/lib/rpm/__db*
```
### Step#2
- Verify the DB
```shell
/usr/lib/rpm/rpmdb_verify Packages && echo DB Ok || echo Corrupted DB
```
### Step#3
- Recreate the rpm DB if step#2 failed or skip to step#4 if step#2 was success
```shell
cd /var/lib/rpm
mv Packages{,.org}
/usr/lib/rpm/rpmdb_dump Packages.orig | /usr/lib/rpm/rpmdb_load Packages
/usr/lib/rpm/rpmdb_verify Packages && echo DB Ok || echo Corrupted DB
rpm -qa
```
### Step#4
- Recreate rpm DB and verify again like step#2
```shell
rpm -vv --rebuilddb
```
