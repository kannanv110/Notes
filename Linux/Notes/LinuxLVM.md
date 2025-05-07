# LVM
 Linux Logical Volume Management (LVM)! It's a powerful and flexible way to manage storage on your Linux system. Instead of dealing with physical partitions directly, LVM introduces an abstraction layer that allows you to create, resize, and manage logical volumes without needing to worry about the underlying physical disk layout Think of it as a virtual layer on top of your physical disks.

## Core LVM Concepts:

 * Physical Volumes (PVs): These are the raw storage devices or partitions that LVM uses. You initialize physical disks or existing partitions to be used by LVM.

 * Volume Groups (VGs): A Volume Group is a collection of one or more Physical Volumes. It acts as a single, large virtual disk from which you can carve out Logical Volumes. A VG can span multiple physical disks.

 * Logical Volumes (LVs): These are the virtual partitions that you create within a Volume Group. Logical Volumes behave like regular block devices (e.g., /dev/mapper/vg0-lv0 or /dev/vg0/lv0) and can be formatted with file systems (like ext4, XFS) and mounted.

## Benefits of Using LVM:

 * Flexibility: You can easily resize Logical Volumes (both increase and decrease their size) without needing to repartition the underlying physical disks or unmount the file system (in many cases).
 * Spanning Multiple Disks: A single Volume Group and its Logical Volumes can span across multiple physical disks, allowing you to combine the storage capacity of several devices.
 * Dynamic Resizing: You can add or remove Physical Volumes from a Volume Group to expand or shrink the total available storage.
 * Snapshots: LVM allows you to create point-in-time snapshots of Logical Volumes. These snapshots can be used for backups or testing without interrupting the active file system.
 * Striping and Mirroring (RAID): LVM supports creating striped Logical Volumes (for increased performance) and mirrored Logical Volumes (for data redundancy).
 * Logical Naming: Logical Volumes have logical names that are independent of the physical disks they reside on, making management easier.

## Command `vgcreate` with various options
`vgcreate` comes with several useful options that allow you to customize the creation of your Volume Groups. Here's an explanation of some common and helpful options with examples:

**Syntax:**

```bash
sudo vgcreate [options] <volume_group_name> <physical_volume_path> [physical_volume_path...]
```

**Common and Useful Options:**

1.  **`-s|--physicalextentsize <size>`**: Specifies the physical extent size. Physical extents are the fundamental units into which Physical Volumes are divided. Logical Volumes are then allocated in terms of these extents. The default size is usually 4MB. Increasing the extent size can be beneficial for very large storage arrays as it reduces the metadata overhead, but it also means that Logical Volumes will be resized in larger increments. The `<size>` can be specified in kilobytes (k), megabytes (m), gigabytes (g), or terabytes (t).

    **Example:** Creating a VG named `myvg` with a physical extent size of 16MB using `/dev/sdb` and `/dev/sdc`:

    ```bash
    sudo vgcreate -s 16m myvg /dev/sdb /dev/sdc
    ```

2.  **`-n|--name <volume_group_name>`**: While the volume group name is required as a positional argument, you can explicitly specify it using this option. This can be useful in scripts for clarity.

    **Example:** Creating a VG named `datavg` using `/dev/sdd`:

    ```bash
    sudo vgcreate -n datavg /dev/sdd
    ```

3.  **`-p|--maxpv <number>`**: Specifies the maximum number of Physical Volumes that can belong to this Volume Group. The default is usually 256. You might need to increase this if you plan to add a very large number of disks to your VG in the future.

    **Example:** Creating a VG named `largevg` that can accommodate up to 1024 PVs:

    ```bash
    sudo vgcreate -p 1024 largevg /dev/sde /dev/sdf
    ```

4.  **`-l|--maxlv <number>`**: Specifies the maximum number of Logical Volumes that can be created within this Volume Group. The default is usually 256. Increase this if you anticipate needing a large number of LVs in this VG.

    **Example:** Creating a VG named `manylvs` that can have up to 512 LVs:

    ```bash
    sudo vgcreate -l 512 manylvs /dev/sdg
    ```

5.  **`-c|--clustered {y|n}`**: Specifies whether the Volume Group should be enabled for clustering. LVM clustering allows multiple nodes in a cluster to share and manage the same Volume Group. This is typically used in high-availability environments.

    **Example:** Creating a clustered VG named `cluster_vg` using `/dev/sdh` and `/dev/sdi`:

    ```bash
    sudo vgcreate -c y cluster_vg /dev/sdh /dev/sdi
    ```

    To create a non-clustered VG (which is the default):

    ```bash
    sudo vgcreate -c n local_vg /dev/sdj
    ```

6.  **`--addtag <tag>`**: Adds a tag to the Volume Group. Tags can be useful for grouping and managing LVM objects. You can later use these tags in other LVM commands to operate on groups of VGs.

    **Example:** Creating a VG named `backup_vg` and tagging it as `backup`:

    ```bash
    sudo vgcreate --addtag backup backup_vg /dev/sdk
    ```

    You can add multiple tags by using the option multiple times:

    ```bash
    sudo vgcreate --addtag backup --addtag critical backup_vg /dev/sdk
    ```

7.  **`--alloc <allocation_policy>`**: Specifies the allocation policy for allocating physical extents to Logical Volumes within this Volume Group. Common policies include:

    * `contiguous`: Attempts to allocate contiguous physical extents. This can improve performance for some workloads but might make it harder to allocate space later if the VG becomes fragmented.
    * `normal`: The default policy, which tries to allocate efficiently but doesn't guarantee contiguity.
    * `any`: Allows allocation on any PV, even if it would violate other constraints (use with caution).
    * `cling`: For mirrored LVs, ensures that each mirror copy resides on a different PV.
    * `strict`: For mirrored LVs, each segment of a mirror must reside on a different PV.

    **Example:** Creating a VG named `contiguous_vg` with a contiguous allocation policy:

    ```bash
    sudo vgcreate --alloc contiguous contiguous_vg /dev/sdl /dev/sdm
    ```

8.  **`--metadatatype <type>`**: Specifies the type of metadata to use for the Volume Group. Common types are `lvm2` (the default and recommended for modern systems) and older types like `lvm1` (which has limitations). You generally won't need to change this unless you have specific compatibility requirements.

    **Example:** Explicitly creating a VG with `lvm2` metadata type:

    ```bash
    sudo vgcreate --metadatatype lvm2 new_vg /dev/sdn
    ```

9.  **`--permission {rw|ro}`**: Sets the initial permissions for the Volume Group metadata. `rw` (read-write) is the default. You might set it to `ro` (read-only) in specific scenarios.

    **Example:** Creating a read-only VG (this is less common):

    ```bash
    sudo vgcreate --permission ro readonly_vg /dev/sdo
    ```

**Combining Options:**

You can combine multiple options in a single `vgcreate` command to tailor the Volume Group to your specific needs.

**Example:** Creating a clustered Volume Group named `web_cluster_vg` with a physical extent size of 32MB, allowing up to 512 LVs, and tagging it as `web`:

```bash
sudo vgcreate -c y -s 32m -l 512 --addtag web web_cluster_vg /dev/sdb /dev/sdc /dev/sdd
```
## Create logical volume with different raid level
### RAID-0(stripping)
```shell
[root@pcsnode1-rocky9 archive]# lvcreate -L 100M -n raid0_lvol -i 2 -I 64k vgdata
  Rounding size 100.00 MiB (25 extents) up to stripe boundary size 104.00 MiB (26 extents).
  Logical volume "raid0_lvol" created.
[root@pcsnode1-rocky9 archive]# lvs -o lv_name,lv_attr,vg_name,vg_attr,devices,stripes,stripe_size
  LV         Attr       VG     Attr   Devices                   #Str Stripe
  raid0_lvol -wi-a----- vgdata wz--n- /dev/sdb1(0),/dev/sdc1(0)    2 64.00k
[root@pcsnode1-rocky9 archive]# 
```

### RAID-1(mirroring)
```shell
[root@pcsnode1-rocky9 archive]# lvcreate -L 100m -m 1 -n raid1_lvol vgdata
  Logical volume "raid1_lvol" created.
[root@pcsnode1-rocky9 archive]# lvs -o lv_name,lv_attr,vg_name,vg_attr,devices,stripes,stripe_size,seg_pe_ran
ges
  LV         Attr       VG     Attr   Devices                                       #Str Stripe PE Ranges                                        
  raid0_lvol -wi-a----- vgdata wz--n- /dev/sdb1(0),/dev/sdc1(0)                        2 64.00k /dev/sdb1:0-12 /dev/sdc1:0-12                    
  raid1_lvol rwi-a-r--- vgdata wz--n- raid1_lvol_rimage_0(0),raid1_lvol_rimage_1(0)    2     0  raid1_lvol_rimage_0:0-24 raid1_lvol_rimage_1:0-24
[root@pcsnode1-rocky9 archive]# 
```

### RAID-5(striping with parity)
 * The disks are divided into data disk and parity disk
 * One disk will be use as parity disk and remaining disks are use as data disk
 * incase of any failure on data disk the data will be recover by using parity disk
```shell
[root@pcsnode1-rocky9 archive]# lvcreate -L 100M -i 3 -n raid5_lvol --type raid5 vgdata
  Using default stripesize 64.00 KiB.
  Rounding size 100.00 MiB (25 extents) up to stripe boundary size 104.00 MiB (26 extents).
  Logical volume "raid5_lvol" created.
[root@pcsnode1-rocky9 archive]# lvs -o lv_name,lv_attr,vg_name,vg_attr,devices,stripes,stripe_size
  LV         Attr       VG     Attr   Devices                                                              #Str Stripe
  raid0_lvol -wi-a----- vgdata wz--n- /dev/sdb1(0),/dev/sdc1(0)                                               2 64.00k
  raid1_lvol rwi-a-r--- vgdata wz--n- raid1_lvol_rimage_0(0),raid1_lvol_rimage_1(0)                           2     0 
  raid5_lvol rwi-a-r--- vgdata wz--n- raid5_lvol_rimage_0(0),raid5_lvol_rimage_1(0),raid5_lvol_rimage_2(0)    3 64.00k
[root@pcsnode1-rocky9 archive]#
```
### RAID-6:
 * RAID 6 is similar to RAID 5 but provides fault tolerance for up to two simultaneous disk failures by using two sets of parity information. It requires at least four disks.

### RAID-10(Stripping with mirror):
```shell
[root@pcsnode1-rocky9 archive]# lvcreate -L 100M -i 2 --type raid10 -m 1 -n raid10_lvol vgdata
  Using default stripesize 64.00 KiB.
  Rounding size 100.00 MiB (25 extents) up to stripe boundary size 104.00 MiB (26 extents).
  Logical volume "raid10_lvol" created.
[root@pcsnode1-rocky9 archive]# ^Cs
[root@pcsnode1-rocky9 archive]# lvs -o lv_name,lv_attr,vg_name,vg_attr,devices,stripes,stripe_size,seg_pe_ranges
  LV          Attr       VG     Attr   Devices                                                                                         #Str Stripe PE Ranges                                                                                              
  raid0_lvol  -wi-a----- vgdata wz--n- /dev/sdb1(0),/dev/sdc1(0)                                                                          2 64.00k /dev/sdb1:0-12 /dev/sdc1:0-12                                                                          
  raid10_lvol rwi-a-r--- vgdata wz--n- raid10_lvol_rimage_0(0),raid10_lvol_rimage_1(0),raid10_lvol_rimage_2(0),raid10_lvol_rimage_3(0)    4 64.00k raid10_lvol_rimage_0:0-12 raid10_lvol_rimage_1:0-12 raid10_lvol_rimage_2:0-12 raid10_lvol_rimage_3:0-12
  raid1_lvol  rwi-a-r--- vgdata wz--n- raid1_lvol_rimage_0(0),raid1_lvol_rimage_1(0)                                                      2     0  raid1_lvol_rimage_0:0-24 raid1_lvol_rimage_1:0-24                                                      
  raid5_lvol  rwi-a-r--- vgdata wz--n- raid5_lvol_rimage_0(0),raid5_lvol_rimage_1(0),raid5_lvol_rimage_2(0)                               3 64.00k raid5_lvol_rimage_0:0-12 raid5_lvol_rimage_1:0-12 raid5_lvol_rimage_2:0-12                             
[root@pcsnode1-rocky9 archive]# lvs
  LV          VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  raid0_lvol  vgdata -wi-a----- 104.00m                                                    
  raid10_lvol vgdata rwi-a-r--- 104.00m                                    100.00          
  raid1_lvol  vgdata rwi-a-r--- 100.00m                                    100.00          
  raid5_lvol  vgdata rwi-a-r--- 104.00m                                    100.00          
[root@pcsnode1-rocky9 archive]# 
```

## Remove ghost disk from the VG
 * ghost disk are not in use on LVM but the actual device removed from server but still on LVM configuration
 * Check ghost disk
 ```shell
 vgreduce --removemissing -f vgname
 ```
 
 Replacing a failed disk in an LVM mirror setup involves these general steps. **It's crucial to be careful and ensure you're working with the correct devices to avoid data loss.**

Here's a breakdown:

**1. Identify the Failed Disk:**

* Use `pvs` (Physical Volumes) to see the status of your PVs. A failed disk might show as `[failed]` or `missing`. Note the device path of the failed PV (e.g., `/dev/sdb`).
* You can also use `lvs -a -o +devices <your_volume_group_name>` to see which PVs are part of your mirrored Logical Volume. The devices listed for the LV will indicate the mirror legs.

**2. Physically Replace the Failed Disk:**

* Power down your system (if hot-swapping isn't supported or you're unsure).
* Physically remove the failed hard drive and install the new, replacement disk. Ensure the new disk is recognized by your system's BIOS/UEFI.

**3. Identify the New Disk's Device Path:**

* After booting up, use commands like `lsblk`, `fdisk -l`, or `blkid` to determine the device path assigned to the new disk (e.g., `/dev/sdc`).

**4. Create a New Physical Volume on the New Disk:**

* Initialize the new disk (or a partition on it) as an LVM Physical Volume:
    ```bash
    sudo pvcreate /dev/new_disk_path
    ```
    Replace `/dev/new_disk_path` with the actual path of your new disk (e.g., `/dev/sdc`).

**5. Extend the Volume Group with the New Physical Volume:**

* Add the new PV to the Volume Group that contains your mirrored Logical Volume:
    ```bash
    sudo vgextend <your_volume_group_name> /dev/new_disk_path
    ```
    Replace `<your_volume_group_name>` with the name of your Volume Group (e.g., `vg0`).

**6. Repair the Mirrored Logical Volume:**

* Use the `lvconvert` command to add the new PV as a mirror to your existing mirrored Logical Volume. Specify the number of mirrors (`-m 1` for a standard two-way mirror) and the Logical Volume path, followed by the new Physical Volume:
    ```bash
    sudo lvconvert -m 1 <your_volume_group_name>/<your_mirrored_lv_name> /dev/new_disk_path
    ```
    Replace `<your_volume_group_name>` with your VG name and `<your_mirrored_lv_name>` with the name of your mirrored LV (e.g., `mylv`).

* **Important:** If the system is aware of the failed leg, you might need to tell `lvconvert` to use the new disk to replace the missing one. LVM might automatically detect the missing leg and start the repair process onto the new disk. If not, you might see messages about an incomplete mirror. In such cases, you might need to use:
    ```bash
    sudo lvconvert --repair <your_volume_group_name>/<your_mirrored_lv_name> /dev/new_disk_path
    ```
    This command instructs LVM to rebuild the mirror onto the specified new disk, using the data from the healthy mirror leg.

**7. Monitor the Mirror Resynchronization:**

* The `lvconvert` command will initiate the process of copying data from the healthy mirror leg to the new disk. You can monitor the progress using:
    ```bash
    sudo lvs -a -o name,sync_percent,devices <your_volume_group_name>
    ```
    Look for your mirrored LV. The `sync_percent` field will show the progress of the resynchronization. Wait until it reaches 100.00%.

**8. (Optional) Remove the Old Physical Volume Entry:**

* Once the new disk is fully synchronized and the mirror is healthy, you *can* remove the entry for the old, failed PV from the Volume Group. **Only do this if you are sure the old disk is physically gone and you don't intend to reuse it in this VG.**
    ```bash
    sudo vgreduce <your_volume_group_name> /dev/old_disk_path
    ```
    Replace `/dev/old_disk_path` with the path of the *failed* disk.

**Example Scenario:**

Let's say your Volume Group is `vg0`, your mirrored Logical Volume is `data_mirror`, and the failed disk was `/dev/sdb`, which you've replaced with a new disk at `/dev/sdc`.

1.  `sudo pvcreate /dev/sdc`
2.  `sudo vgextend vg0 /dev/sdc`
3.  `sudo lvconvert -m 1 vg0/data_mirror /dev/sdc`
4.  `sudo lvs -a -o name,sync_percent,devices vg0` (Monitor sync progress)
5.  (After sync) `sudo vgreduce vg0 /dev/sdb` (Optional, if you're sure about removing the old entry)

**Important Considerations:**

* **Data Integrity:** Ensure the replacement disk is the same size or larger than the failed disk. If it's smaller, the `lvconvert` operation might fail.
* **Backup:** It's always wise to have a recent backup before performing any disk replacement or LVM operations.
* **Monitoring:** Keep an eye on your system logs for any errors during the process.
* **Hot-Swapping:** If your hardware supports hot-swapping, you might be able to replace the disk without powering down. Consult your hardware documentation.
* **LVM Metadata:** LVM stores its configuration in metadata on the PVs and VGs. Ensure the metadata is consistent.

By following these steps carefully, you should be able to successfully replace a failed disk in your LVM mirror setup and restore redundancy to your Logical Volume.

Alright, let's talk about Linux LVM snapshots! Think of them as lightweight, point-in-time copies of your Logical Volumes (LVs). They allow you to capture the state of an LV at a specific moment without interrupting its use. This is incredibly useful for backups, testing changes, or performing maintenance tasks safely.

**Key Concepts:**

* **Point-in-Time Copy:** A snapshot doesn't copy all the data immediately. Instead, it records the state of the original LV's data blocks at the moment the snapshot is created.
* **Copy-on-Write (COW):** When a block in the original LV is about to be changed *after* the snapshot is taken, the original content of that block is copied to the snapshot area *before* the change is written to the original LV. This ensures the snapshot retains the original data.
* **Space Efficiency:** Initially, a snapshot consumes very little space, only the metadata about the original LV's state. It grows only as changes are made to the original LV.
* **Dependencies:** A snapshot is dependent on its original LV (the "origin volume"). If the origin volume is removed, the snapshot becomes unusable.
* **Read-Only or Read-Write:** Snapshots can be created as either read-only (the default) or read-write. Read-write snapshots allow you to make changes to the snapshot without affecting the origin volume, which is useful for testing.

**Creating LVM Snapshots:**

You use the `lvcreate` command with the `-s` or `--snapshot` option. You also need to specify the size of the snapshot LV using the `-L` option. The size you allocate for the snapshot determines how much change the origin volume can undergo before the snapshot runs out of space and becomes invalid.

**Syntax:**

```bash
sudo lvcreate -s -L <snapshot_size> -n <snapshot_name> <origin_vg_name>/<origin_lv_name>
```

* `-s` or `--snapshot`: Specifies that you are creating a snapshot.
* `-L <snapshot_size>`: The size you allocate for the snapshot LV. This should be large enough to hold all the changes you expect to make to the origin volume during the snapshot's lifetime. A good starting point might be 10-20% of the origin volume's size, but it depends on the workload.
* `-n <snapshot_name>`: The name you want to give to your snapshot LV.
* `<origin_vg_name>/<origin_lv_name>`: The full path to the origin Logical Volume (e.g., `myvg/mylv`).

**Example:**

Let's say you have a Logical Volume named `data_lv` in the Volume Group `vg0`, and its size is 100GB. You want to create a snapshot of it named `data_snap` with a size of 10GB:

```bash
sudo lvcreate -s -L 10g -n data_snap vg0/data_lv
```

**Mounting and Using Snapshots:**

Once created, a snapshot LV behaves like any other block device. You can mount it to a directory to access the data as it was at the moment the snapshot was taken.

```bash
sudo mkdir /mnt/snapshot
sudo mount /dev/vg0/data_snap /mnt/snapshot
```

Now you can browse the contents of `/mnt/snapshot` to see the data as it was when `data_snap` was created. Any changes made to `/dev/vg0/data_lv` *after* the snapshot was taken will not be reflected in `/mnt/snapshot`.

**Read-Write Snapshots:**

You can create a read-write snapshot by simply mounting it with read-write permissions. This allows you to test changes or perform maintenance on a copy of your data without affecting the original.

```bash
sudo mount -o rw /dev/vg0/data_snap /mnt/snapshot
```

Any modifications you make within `/mnt/snapshot` will be written to the snapshot LV's allocated space, not to the origin volume.

**Listing Snapshots:**

You can list the existing snapshots using the `lvs` command:

```bash
sudo lvs --all
```

Snapshots are typically listed as having an "origin" LV associated with them.

**Merging Snapshots:**

If you created a read-write snapshot and are satisfied with the changes, you can merge the snapshot back into the origin volume. **This is a destructive operation on the origin volume, as it will be overwritten with the data from the snapshot.**

```bash
sudo lvconvert --merge /dev/vg0/data_snap
```

**Warning:** Merging a snapshot is irreversible and will modify the origin volume. Ensure you understand the implications before proceeding. The origin volume must be unmounted for the merge to occur.

**Removing Snapshots:**

If you no longer need a snapshot, you can remove it using the `lvremove` command:

```bash
sudo lvremove /dev/vg0/data_snap
```

**Important Considerations for Snapshot Size:**

* The size you allocate for the snapshot is crucial. If the origin volume undergoes more changes than the snapshot size can accommodate, the snapshot will become invalid ("out of space" or "broken").
* Monitor the snapshot usage using `lvs -o name,size,data_percent vg0/data_snap`. The `data_percent` field shows how full the snapshot is.
* You can try to resize a snapshot using `lvresize`, but it's generally recommended to create a snapshot with an adequately estimated size initially.

**Use Cases for LVM Snapshots:**

* **Backups:** Create a snapshot before performing a backup to ensure a consistent state of the data. You can then back up the snapshot while the origin volume remains in use.
* **Software Testing:** Take a snapshot of your system before installing or upgrading software. If something goes wrong, you can revert to the snapshot.
* **Database Operations:** Create a snapshot of a database before performing risky operations like schema changes. If the operation fails, you can revert to the snapshot.
* **Virtual Machine Management:** Snapshots are commonly used in virtualization to save the state of a virtual machine.

LVM snapshots are a powerful tool for managing and protecting your data. Understanding their behavior and limitations is key to using them effectively. Remember to monitor their size and remove them when they are no longer needed to conserve disk space.

## Steps to migrate storage online
Migrating LVM data from one storage to another online on Linux can be achieved using the mirroring capabilities of LVM. This method allows you to copy the data to the new storage while the logical volume remains active and accessible. Here are the steps:

**1. Prerequisites:**

* **New Storage:** Ensure the new storage (physical volumes) is available and recognized by your system.
* **Sufficient Space:** The new storage must have at least the same amount of free space as the currently used space in the logical volume you intend to migrate.
* **Identify LVM Components:** Know the names of the physical volume(s) (PVs) you want to migrate *from*, the volume group (VG) they belong to, and the logical volume(s) (LVs) you want to migrate. Also, identify the new PV(s) you will be migrating *to*.

**2. Add the New Physical Volume(s) to the Volume Group:**

   If the new storage is not yet part of the volume group containing the LV you want to migrate, you need to add it. First, create a physical volume on the new storage:

   ```bash
   sudo pvcreate /dev/<new_device_path>
   ```

   Replace `/dev/<new_device_path>` with the actual device path of your new storage (e.g., `/dev/sdd1`).

   Then, extend the volume group to include the new PV:

   ```bash
   sudo vgextend <volume_group_name> /dev/<new_device_path>
   ```

   Replace `<volume_group_name>` with the name of your volume group (e.g., `vg00`).

**3. Mirror the Logical Volume to the New Storage:**

   Use the `lvconvert` command to add a mirror to your logical volume, with the new storage as the mirror leg. This will start the process of copying the data online.

   ```bash
   sudo lvconvert -m 1 --corelog <logical_volume_path> /dev/<new_device_path>
   ```

   * `-m 1`: Specifies that you want one mirror (resulting in two copies of your data).
   * `--corelog`: Enables persistent core logging for the mirror, which improves resynchronization speed after a failure.
   * `<logical_volume_path>`: The full path to your logical volume (e.g., `/dev/vg00/mylv`).
   * `/dev/<new_device_path>`: The device path of the new physical volume you added.

   If you are migrating to multiple new PVs for better performance or capacity, you can specify them here. LVM will attempt to spread the mirror across these PVs.

**4. Monitor the Mirroring Process:**

   You can check the synchronization status of the mirror using the `lvs` or `lvdisplay` command. Look for the `sync` percentage.

   ```bash
   sudo lvs <logical_volume_name> -o name,copy_percent,devices
   ```

   or

   ```bash
   sudo lvdisplay <logical_volume_path>
   ```

   Wait until the `Copy%` reaches 100% before proceeding. This indicates that all data has been copied to the new storage.

**5. Remove the Old Physical Volume(s) from the Logical Volume (Mirror):**

   Once the mirror is synchronized, you can remove the mirror leg that resides on the old storage. This effectively moves the active copy of your data to the new storage.

   ```bash
   sudo lvconvert -m 0 <logical_volume_path> /dev/<old_device_path>
   ```

   * `-m 0`: Specifies that you want to have zero mirrors, effectively removing the specified leg.
   * `<logical_volume_path>`: The path to your logical volume.
   * `/dev/<old_device_path>`: The device path of the physical volume(s) you want to remove from this LV's mirror. If the LV spanned multiple PVs on the old storage, you might need to repeat this command for each old PV.

**6. Remove the Old Physical Volume(s) from the Volume Group (Optional):**

   After you have removed all logical volumes from the old PV(s), you can remove the old PV(s) from the volume group if you intend to retire the old storage.

   First, ensure the PV is no longer in use by any LV in the VG:

   ```bash
   sudo pvs -o+vgs
   ```

   Then, remove the PV:

   ```bash
   sudo vgreduce <volume_group_name> /dev/<old_device_path>
   ```

   Finally, you can remove the physical volume entry:

   ```bash
   sudo pvremove /dev/<old_device_path>
   ```

**Important Considerations:**

* **Performance:** During the mirroring process, there might be a slight performance impact as data is being written to both the old and new storage.
* **Error Handling:** Monitor the process closely for any errors. If an error occurs, consult the LVM documentation for troubleshooting steps.
* **Data Integrity:** While this method is designed for online migration, it's always wise to have a recent backup before performing any storage-related operations.
* **Boot Volumes:** Migrating boot volumes online is more complex and might require additional steps related to the bootloader configuration. The above steps are primarily for data volumes.
* **VCS Environment:** If the LVM volume is part of a Veritas Cluster Server (VCS) environment, ensure you perform these steps on the active node that owns the volume group. The service group containing the volume should remain online during the migration.

This step-by-step guide provides a general approach to migrating LVM data online. Remember to replace the placeholder device paths and volume group/logical volume names with your actual values. Always consult the `man` pages for the LVM commands (`pvcreate`, `vgextend`, `lvconvert`, `lvs`, `lvdisplay`, `vgreduce`, `pvremove`) for more detailed information and options.