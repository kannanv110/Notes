Migrating VxVM data from one storage to another online involves creating a mirrored copy of your existing volumes on the new storage and then removing the original plexes. This process minimizes downtime as the application continues to run while the data is being copied. Here are the general steps involved:

**1. Prerequisites:**

* **New Storage Presentation:** Ensure the new storage (LUNs) is presented to all the nodes in your VCS cluster and is visible to the operating system.
* **VxVM Visibility:** Verify that VxVM can see the new LUNs using `vxdisk list`. They will likely show up as `online invalid`.
* **Sufficient Space:** The new storage must have enough capacity to hold a copy of the data you intend to migrate.
* **Disk Group Considerations:** Decide whether you will add the new storage to the existing disk group or create a new one. Adding to the existing group is generally simpler for migration.

**2. Add New Disks to the Disk Group:**

* If you are adding the new storage to an existing disk group, use the `vxdg adddisk` command on one of the cluster nodes:

    ```bash
    sudo vxdg -g <diskgroup_name> adddisk <new_disk_name>=<OS_device_path>
    ```

    * `<diskgroup_name>`: The name of the VxVM disk group containing the volume you want to migrate.
    * `<new_disk_name>`: A name you want to give to the new disk within VxVM.
    * `<OS_device_path>`: The operating system device path of the new LUN (e.g., `/dev/sdd`).

    **Example:**

    ```bash
    sudo vxdg -g mydg adddisk new_disk01=/dev/sdd
    ```

* Verify the disk has been added using `vxdisk list`.

**3. Mirror the Volume to the New Storage:**

* Use the `vxassist mirror` command to create a new plex (copy) of the volume on the new storage. This command performs a background copy of the data.

    ```bash
    sudo vxassist -g <diskgroup_name> mirror <volume_name> <number_of_copies> \
    layout=concat diskgroup=<diskgroup_name> disk=<new_disk_name>
    ```

    * `<diskgroup_name>`: The name of the disk group.
    * `<volume_name>`: The name of the volume you are migrating.
    * `<number_of_copies>`: Typically `1` for a mirror.
    * `layout=concat`: Specifies a concatenated layout for the new plex.
    * `diskgroup=<diskgroup_name>`: Explicitly specifies the disk group.
    * `disk=<new_disk_name>`: Specifies the new disk to use for the mirror.

    **Example:**

    ```bash
    sudo vxassist -g mydg mirror myvol 1 layout=concat diskgroup=mydg disk=new_disk01
    ```

* You can specify multiple new disks if you want to stripe the new plex for potential performance benefits.

**4. Monitor the Mirroring Process:**

* Use the `vxtask list` command to monitor the progress of the data synchronization.

    ```bash
    sudo vxtask list
    ```

    Look for tasks related to mirroring the volume. The `STATE` will show the progress.

* You can also use `vxprint -vt <volume_name>` to see the status of the plexes. The new plex will initially be in a `WCOPY` (write copy) state and will change to `ACTIVE` once the synchronization is complete.

**5. Verify Synchronization:**

* Once the `vxtask list` shows the mirroring task as completed and `vxprint -vt <volume_name>` shows the new plex as `ACTIVE` and `RW` (read-write), the data is fully synchronized on the new storage.

**6. Remove the Original Plex(es) from the Old Storage:**

* Identify the plex(es) residing on the old storage using `vxprint -vt <volume_name>`. Look for the `SD` (subdisk) entries that point to the old disks.
* Use the `vxplex -o rm dis` command to remove the original plex(es). **Be absolutely sure you are removing the plexes from the old storage.**

    ```bash
    sudo vxplex -g <diskgroup_name> -o rm dis <plex_name>
    ```

    * `<diskgroup_name>`: The name of the disk group.
    * `<plex_name>`: The name of the plex you want to remove (e.g., `myvol-01`).

    **Example:**

    ```bash
    sudo vxplex -g mydg -o rm dis myvol-01
    ```

    If your volume was mirrored on multiple disks on the old storage, you might have multiple plexes to remove.

**7. Remove the Old Disks from the Disk Group (Optional but Recommended):**

* Once you have verified that the volume is running entirely on the new storage, you can remove the old disks from the disk group using the `vxdg rmdisk` command:

    ```bash
    sudo vxdg -g <diskgroup_name> rmdisk <old_disk_name>
    ```

    * `<diskgroup_name>`: The name of the disk group.
    * `<old_disk_name>`: The VxVM name of the disk you want to remove.

    **Example:**

    ```bash
    sudo vxdg -g mydg rmdisk old_disk01
    ```

* Before removing, ensure no volumes or other VxVM objects are still using these disks.

**8. Uninitialize the Old Disks (Optional):**

* If you intend to repurpose the old storage, you can uninitialize the VxVM metadata from the disks using `vxdiskunsetup`:

    ```bash
    sudo vxdiskunsetup <OS_device_path>
    ```

    **Example:**

    ```bash
    sudo vxdiskunsetup /dev/sda
    ```

**Important Considerations for VCS:**

* **Run Commands on the Master Node:** Execute these VxVM commands from the VCS master node for the disk group.
* **Service Group Awareness:** If the volume you are migrating is part of a VCS service group, ensure the service group remains online throughout the migration process. VCS will manage the volume's state on the active node.
* **Avoid Simultaneous Operations:** Do not perform other major VxVM operations on the same volume or disk group during the migration.
* **Thorough Testing:** After the migration, thoroughly test your application to ensure data integrity and performance on the new storage.
* **Backups:** Always have a valid backup before performing any storage migration.

This step-by-step process allows you to migrate your VxVM data to new storage online with minimal disruption to your applications in a VCS environment. Remember to adapt the commands and device paths to your specific configuration. Always consult the Veritas documentation for the most accurate and detailed instructions.