## Steps to follow to attach the failed disk which came online
It's not directly a command to "check whether the failed disk can be attached". The ability to attach a failed disk back to a disk group depends on the *nature* of the failure and whether the underlying hardware issue has been resolved.

Here's a breakdown of how to assess the situation and attempt to re-attach a failed disk in VxVM:

**1. Identify the Failed Disk:**

Use the `vxdisk list` command to identify the disk that is in a `failed` or `failed was` state.

```bash
sudo /etc/vx/bin/vxdisk list
```

The output will show the `STATUS` of each disk. Look for entries like:

```
DEVICE       TYPE        DISK         GROUP      STATUS
mydisk01     auto:cdsdisk mydg         mydg       online
mydisk02     auto:cdsdisk -            -          failed was: <original_device>
```

**2. Investigate the Cause of the Failure:**

Before attempting to re-attach, it's crucial to understand *why* the disk failed. This might involve:

* **Checking system logs:** Examine `/var/log/messages` or other relevant system logs for hardware errors related to the disk.
* **Checking hardware status:** Use hardware-specific tools or interfaces (e.g., RAID controller utilities, storage array management) to determine the physical status of the disk.
* **Verifying connectivity:** Ensure cables are properly connected and there are no physical connectivity issues.

**3. Attempt to Re-attach the Disk:**

Once you believe the underlying issue has been resolved, you can attempt to re-attach the disk using the `vxreattach` command:

```bash
sudo /etc/vx/bin/vxreattach <disk_media_name>
```

Replace `<disk_media_name>` with the name of the failed disk as listed in the `DISK` column of `vxdisk list`.

**Example:**

If `vxdisk list` shows:

```
DEVICE       TYPE        DISK         GROUP      STATUS
mydisk02     auto:cdsdisk failed_disk  mydg       failed was: /dev/sdd
```

You would run:

```bash
sudo /etc/vx/bin/vxreattach failed_disk
```

**What `vxreattach` does:**

* Attempts to re-establish the connection between the VxVM disk media record and the underlying physical device.
* Tries to bring the disk back online within the disk group it belonged to.

**4. Check if Re-attachment was Successful:**

After running `vxreattach`, use `vxdisk list` again to check the status of the disk. If successful, the `STATUS` should change to `online`.

**5. Recover Volumes (if necessary):**

If the failed disk was part of a redundant volume (like a mirror or RAID-5), you might need to initiate a recovery process to resynchronize the data onto the re-attached disk:

```bash
sudo /etc/vx/bin/vxrecover -g <diskgroup_name> <volume_name>
```

If the entire disk group was affected, you might need to import the disk group if it's not already:

```bash
sudo /etc/vx/bin/vxdg import <diskgroup_name>
```

**Important Considerations:**

* **Underlying Issue:** If the physical problem that caused the disk to fail persists, re-attaching it in VxVM will likely be unsuccessful or lead to further issues.
* **Permanent Failure:** If the disk has suffered a permanent hardware failure, you will not be able to re-attach it. In such cases, you'll need to replace the failed disk.
* **Replacing a Failed Disk:** The proper procedure for replacing a failed disk in VxVM involves using commands like `vxdisk rm` (to remove the failed disk record) and `vxdg adddisk` (to add the new disk), or using the `vxdiskadm` utility.
* **`vxreattach -c` (Check Only):** You can use the `-c` option with `vxreattach` to check if a re-attachment is possible without actually performing the operation:

    ```bash
    sudo /etc/vx/bin/vxreattach -c <disk_media_name>
    ```

    This will provide information about whether VxVM can find a matching disk to re-attach.

**In summary, there isn't a single "check" command in VxVM to definitively say if a failed disk *can* be attached. You need to investigate the cause of the failure and then attempt the re-attachment using `vxreattach`. The success depends on whether the underlying problem has been resolved and if VxVM can recognize and utilize the disk again.**