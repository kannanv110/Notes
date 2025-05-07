# Parted(disk partition)

## Points to remember
 * **Permissions**: You'll usually need sudo to run parted as it requires root privileges to modify disk partitions.
 * **Data Loss**: Be extremely cautious when using commands like mklabel, rm, and resize. Incorrect usage can lead to permanent data loss. Always double-check your commands and consider backing up your data beforehand.
 * **File System**: parted primarily deals with partitions. You'll typically need to use other tools like mkfs (e.g., mkfs.ext4 /dev/sdb1) to create a file system on the newly created or resized partition.
 * **Kernel Awareness**: After making changes with parted, the Linux kernel might not immediately recognize the new partition table or partition sizes. You might need to reboot your system or use commands like partprobe or udevadm settle to inform the kernel about the changes.
## Create partition with GPT table
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb mklabel gpt
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print                           
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start  End  Size  File system  Name  Flags

[root@pcsnode1-rocky9 ~]# 
```

## Create primary partition with 100Mb size
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb mkpart primary ext3 1 100MB    
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               primary

[root@pcsnode1-rocky9 ~]# 
```

## Resize the partition
 * dont accept the sizes +500M like(LVM)
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb resizepart 1 +100M
Error: Invalid number.
[root@pcsnode1-rocky9 ~]# parted /dev/sdb resizepart 1 200M              
Information: You may need to update /etc/fstab.
```
 * We have to mention the desired size of the partition
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End    Size   File system  Name     Flags
 1      1049kB  200MB  199MB               primary

[root@pcsnode1-rocky9 ~]# 
```
 * We can't resize the partition by overlapping to another partition
 * In this example we have 2 partitons and we can't resize(extend) 
   the partition#1 /dev/sdb1.
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End    Size   File system  Name     Flags
 1      1049kB  200MB  199MB               primary

[root@pcsnode1-rocky9 ~]# parted /dev/sdb mkpart primary 201M 300M
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End    Size    File system  Name     Flags
 1      1049kB  200MB  199MB                primary
 2      201MB   300MB  98.6MB               primary

[root@pcsnode1-rocky9 ~]# parted /dev/sdb resizepart 1 400M
Error: Can't have overlapping partitions.
[root@pcsnode1-rocky9 ~]# 
```

## Remove the partition
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End    Size    File system  Name     Flags
 1      1049kB  200MB  199MB                data
 2      201MB   300MB  98.6MB               primary

[root@pcsnode1-rocky9 ~]# parted /dev/sdb rm 1
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb rm 2
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print                           
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start  End  Size  File system  Name  Flags

[root@pcsnode1-rocky9 ~]# 
```
## Create partition to the end of the disk
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               logical

[root@pcsnode1-rocky9 ~]# parted /dev/sdb mkpart primary 100M 100%
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               logical
 2      99.6MB  1073MB  973MB                primary

[root@pcsnode1-rocky9 ~]#
```

## Set flags on the partitions
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdb print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               logical
 2      99.6MB  1073MB  973MB                primary

[root@pcsnode1-rocky9 ~]# parted /dev/sdb set 1 boot on
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print                   
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               logical  boot, esp
 2      99.6MB  1073MB  973MB                primary

[root@pcsnode1-rocky9 ~]# parted /dev/sdb set 2 swap on
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print                   
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               logical  boot, esp
 2      99.6MB  1073MB  973MB                primary  swap

[root@pcsnode1-rocky9 ~]# parted /dev/sdb set 2 lvm on
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdb print                    
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdb: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: pmbr_boot

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  99.6MB  98.6MB               logical  boot, esp
 2      99.6MB  1073MB  973MB                primary  lvm

[root@pcsnode1-rocky9 ~]# 
```

## Create partition with full size of the disk
```shell
[root@pcsnode1-rocky9 ~]# parted /dev/sdc mklabel gpt
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdc mkpart primary 0% 100%
Information: You may need to update /etc/fstab.

[root@pcsnode1-rocky9 ~]# parted /dev/sdc print                           
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sdc: 1074MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  1073MB  1072MB               primary

[root@pcsnode1-rocky9 ~]#
```
