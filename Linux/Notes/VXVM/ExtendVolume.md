To extend a Veritas Volume Manager (VxVM) volume on Linux, you can use the `vxassist` or `vxresize` command. The preferred method, especially if the volume contains a Veritas File System (VxFS), is `vxresize` as it can resize both the volume and the file system in a single step.

Here are the steps using both methods:

**Method 1: Using `vxresize` (Recommended for VxFS)**

This method assumes the underlying storage has already been extended at the hardware level and is visible to the operating system.

1.  **Verify Free Space in the Disk Group:**
    Before extending the volume, ensure there is enough free space in the disk group.

    ```bash
    sudo vxassist -g <diskgroup_name> maxgrow <volume_name>
    ```

    This command will show the maximum amount by which the volume can be extended.

2.  **Extend the Volume and File System:**
    Use the `vxresize` command to extend the volume and its VxFS file system simultaneously.

    ```bash
    sudo /etc/vx/bin/vxresize -g <diskgroup_name> <volume_name> +<size>
    ```

    * `<diskgroup_name>`: The name of the VxVM disk group.
    * `<volume_name>`: The name of the volume you want to extend.
    * `+<size>`: The amount by which you want to extend the volume. You can specify the size in sectors (default), kilobytes (k), megabytes (m), gigabytes (g), or terabytes (t). The `+` sign indicates an increase in size.

    **Example (extending by 1GB):**

    ```bash
    sudo /etc/vx/bin/vxresize -g mydg myvol +1g
    ```

    **Example (extending to a specific size of 10GB):**

    ```bash
    sudo /etc/vx/bin/vxresize -g mydg myvol 10g
    ```

3.  **Verify the New Size:**
    After the resize operation, verify the new size of the volume and the file system using the `vxprint` and `df` commands.

    ```bash
    sudo vxprint -htg <diskgroup_name> <volume_name>
    df -h <mount_point>
    ```

**Method 2: Using `vxassist` (For non-VxFS or separate file system resize)**

If the volume does not contain a VxFS file system, or if you prefer to resize the volume and file system separately, you can use `vxassist`.

1.  **Verify Free Space in the Disk Group:** (Same as step 1 above)

    ```bash
    sudo vxassist -g <diskgroup_name> maxgrow <volume_name>
    ```

2.  **Extend the Volume:**
    Use the `vxassist growby` or `vxassist growto` command to extend the volume.

    * **`growby`**: Extends the volume by a specified amount.

        ```bash
        sudo vxassist -g <diskgroup_name> growby <volume_name> <size>
        ```

        **Example (extending by 500MB):**

        ```bash
        sudo vxassist -g mydg growby myvol 500m
        ```

    * **`growto`**: Extends the volume to a specific total size.

        ```bash
        sudo vxassist -g <diskgroup_name> growto <volume_name> <new_size>
        ```

        **Example (extending to a total size of 5GB):**

        ```bash
        sudo vxassist -g mydg growto myvol 5g
        ```

3.  **Resize the File System (if applicable):**
    If the volume contains a file system other than VxFS (e.g., ext4, XFS), you need to resize the file system separately using the appropriate operating system commands. This step might require the file system to be mounted.

    * **ext4:**

        ```bash
        sudo resize2fs <device_path>
        ```

        Replace `<device_path>` with the block device path of the volume (e.g., `/dev/vx/dsk/mydg/myvol`). You can often run this command while the file system is mounted.

    * **XFS:**

        ```bash
        sudo xfs_growfs <mount_point>
        ```

        Replace `<mount_point>` with the mount point of the file system. This command must be run while the file system is mounted.

4.  **Verify the New Size:** (Same as step 3 in Method 1)

    ```bash
    sudo vxprint -htg <diskgroup_name> <volume_name>
    df -h <mount_point>
    ```

**Important Considerations:**

* **Online Extension:** Both `vxresize` and `vxassist` allow you to extend volumes online without unmounting the file system in most cases.
* **Underlying Storage:** Ensure that the underlying physical storage (LUNs) has been expanded before attempting to extend the VxVM volume. VxVM can only use the space that is presented to it by the operating system. You might need to use storage array management tools to extend the LUNs. After extending the LUNs, you might need to inform the operating system about the change (e.g., by rescanning the SCSI bus).
* **Disk Group Space:** Always check the available free space in the disk group before attempting to extend a volume.
* **Volume Layout:** The ability to extend a volume and the efficiency of the extension can depend on the volume's layout (e.g., concatenated, striped, mirrored).
* **VCS Environment:** If the volume is part of a Veritas Cluster Server (VCS) environment, ensure you run the commands from the active node that owns the disk group. The service group containing the volume should typically be online during the extension.
* **Backups:** It's always a good practice to have a recent backup before performing any storage-related operations.

Refer to the Veritas Volume Manager documentation for more detailed information and specific use cases. The `man` pages for `vxassist` and `vxresize` are also valuable resources.