# VxVM disk group creation

Creating a Veritas Disk Group on a disk in Linux involves using the Veritas Volume Manager (VxVM) command-line interface. Here's a step-by-step guide:

**Prerequisites:**

* **Veritas Volume Manager (VxVM) installed:** Ensure that the Veritas Volume Manager software is installed on your Linux system.
* **Identify the disk:** You need to know the device name of the disk you want to add to the disk group (e.g., `/dev/sdb`, `/dev/mapper/...). Use commands like `fdisk -l` or `lsblk` to identify the correct disk.
* **Disk should not be in use:** The disk should not contain any active file systems or be part of another volume manager (like LVM) before adding it to a Veritas Disk Group.

**Steps:**

1.  **Initialize the disk for VxVM (if not already):**
    If the disk is not yet recognized by Veritas Volume Manager, you need to initialize it. Use the `vxdisksetup` command:

    ```bash
    sudo /etc/vx/bin/vxdisksetup -i <device_name>
    ```

    Replace `<device_name>` with the actual device path of the disk (e.g., `/dev/sdb`).
    * The `-i` option initializes the disk for use by VxVM.
    * By default, this will create a sliced disk layout. You can specify other formats like `cdsdisk` if needed, but `sliced` is generally recommended for compatibility.

2.  **Create the Disk Group:**
    Use the `vxdg init` command to create a new disk group. You need to provide a name for the disk group and specify the disk(s) to include.

    ```bash
    sudo /etc/vx/bin/vxdg init <diskgroup_name> <disk_name>=<device_name>
    ```

    * `<diskgroup_name>`: Choose a name for your disk group (e.g., `mydg`).
    * `<disk_name>`: This is a logical name you assign to the disk within the disk group (e.g., `mydisk01`).
    * `<device_name>`: This is the actual device path of the disk (e.g., `/dev/sdb`).

    **Example:** To create a disk group named `datavg` using the disk `/dev/sdb` and naming it `disk01` within the group:

    ```bash
    sudo /etc/vx/bin/vxdg init datavg disk01=/dev/sdb
    ```

    You can add multiple disks to the disk group during initialization:

    ```bash
    sudo /etc/vx/bin/vxdg init datavg disk01=/dev/sdb disk02=/dev/sdc
    ```

3.  **Verify the Disk Group:**
    Use the `vxdg list` command to verify that the disk group has been created:

    ```bash
    sudo /etc/vx/bin/vxdg list
    ```

    You should see your newly created disk group in the output.

4.  **Verify the Disk in the Disk Group:**
    Use the `vxdisk list` command to see the status of the disks known to VxVM and their membership in disk groups:

    ```bash
    sudo /etc/vx/bin/vxdisk list
    ```

    You should see the disk you added listed under the disk group you created.

**Adding Disks to an Existing Disk Group:**

If you have an existing disk group and want to add more disks to it, follow these steps:

1.  **Initialize the new disk (if necessary):**
    As in step 1 above, if the new disk isn't initialized for VxVM, use `vxdisksetup`:

    ```bash
    sudo /etc/vx/bin/vxdisksetup -i <new_device_name>
    ```

2.  **Add the disk to the existing Disk Group:**
    Use the `vxdg adddisk` command:

    ```bash
    sudo /etc/vx/bin/vxdg -g <diskgroup_name> adddisk <new_disk_name>=<new_device_name>
    ```

    * `-g <diskgroup_name>`: Specifies the name of the disk group you want to add the disk to.
    * `<new_disk_name>`: A logical name for the new disk within the group.
    * `<new_device_name>`: The device path of the new disk.

    **Example:** To add the disk `/dev/sdd` as `disk03` to the existing disk group `datavg`:

    ```bash
    sudo /etc/vx/bin/vxdg -g datavg adddisk disk03=/dev/sdd
    ```

3.  **Verify the Disk Group:**
    Use `vxdg list` and `vxdisk list` to confirm that the new disk has been added to the disk group.

**Important Considerations:**

* **Disk Naming:** Choose meaningful logical names for your disks within the disk group.
* **Disk Group Name:** Select a descriptive name for your disk group that reflects its purpose.
* **Permissions:** Ensure you have root privileges (using `sudo`) to execute these commands.
* **Error Handling:** Pay attention to the output of the commands for any error messages.
* **VxVM Documentation:** Refer to the official Veritas Volume Manager documentation for more advanced options and troubleshooting.

After creating the disk group and adding disks, you can then proceed to create Veritas volumes (logical drives) within that disk group, which can then be formatted with a file system and mounted.