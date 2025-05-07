The process of replacing a failed disk in Veritas Volume Manager (VxVM) involves several steps. Here's a general guide, and it's crucial to consult your system's specific hardware and VxVM documentation for the most accurate procedure.

**Using the `vxdiskadm` Utility (Recommended for Simplicity):**

`vxdiskadm` provides a menu-driven interface that simplifies disk management tasks, including replacements.

1.  **Identify the Failed Disk:** Use `vxdisk list` to determine the device name and VxVM disk name of the failed disk. Look for disks with a `failed` or `failed was` status.

    ```bash
    sudo /etc/vx/bin/vxdisk list
    ```

2.  **Launch `vxdiskadm`:**

    ```bash
    sudo /etc/vx/bin/vxdiskadm
    ```

3.  **Navigate to the Disk Menu:** In the main menu, select **"Disk Operations"** (usually option `D` or `1`).

4.  **Select "Replace a failed or removed disk"**: Choose the option that corresponds to replacing a failed disk (usually option `5`).

5.  **Select the Failed Disk:** You will be prompted to enter the VxVM disk name of the disk you want to replace. Enter the name you identified in step 1.

6.  **Select the Replacement Disk:** You will be presented with a list of available disks that are not currently part of any disk group. Choose the disk that will be the replacement. If the new disk is not yet initialized for VxVM, the utility will likely prompt you to initialize it.

7.  **Confirm the Replacement:** Review the details and confirm the replacement operation. `vxdiskadm` will handle the necessary steps in the background, including potentially initializing the new disk, adding it to the disk group with the same disk media name as the failed disk, and initiating data recovery (if the volume was part of a redundant configuration).

8.  **Exit `vxdiskadm`:** Once the operation is complete, you can exit the utility.

9.  **Verify the Status:** Use `vxdisk list` and `vxprint -pht -g <diskgroup_name> <volume_name>` to check the status of the new disk and any affected volumes. Ensure the new disk is `online` and any recovery/resynchronization is underway or complete.

**Manual Command-Line Steps:**

If you prefer to use the command line directly, follow these steps:

1.  **Identify the Failed Disk:** Use `vxdisk list` to determine the device name and VxVM disk name of the failed disk.

    ```bash
    sudo /etc/vx/bin/vxdisk list
    ```

2.  **Physically Replace the Disk:** Power down the system (if necessary for your hardware) and physically replace the failed disk with the new one. Ensure the new disk is of the same type and similar or larger capacity.

3.  **Make the New Disk Visible to the OS:** After powering on (if needed), ensure the operating system recognizes the new disk. You might need to perform a device scan or use OS-specific commands (e.g., `devfsadm -C -c disk` on Solaris/HP-UX).

4.  **Initialize the New Disk for VxVM (if not already):** If the new disk has never been used by VxVM, you need to initialize it:

    ```bash
    sudo /etc/vx/bin/vxdisksetup -i <new_device_name>
    ```

    Replace `<new_device_name>` with the operating system device path of the new disk (e.g., `/dev/sdb`).

5.  **Add the New Disk to the Disk Group with the Same Media Name:** This is crucial for VxVM to recognize it as the replacement. Use the `vxdg adddisk` command with the `-k` option to keep the original disk media name:

    ```bash
    sudo /etc/vx/bin/vxdg -g <diskgroup_name> -k adddisk <original_disk_media_name>=<new_device_name>
    ```

    Replace `<diskgroup_name>` with the name of your disk group, `<original_disk_media_name>` with the VxVM disk name of the failed disk, and `<new_device_name>` with the OS device path of the new disk.

6.  **Recover Volumes:** If the failed disk was part of a redundant volume, start the recovery process:

    ```bash
    sudo /etc/vx/bin/vxrecover -g <diskgroup_name> <volume_name>
    ```

    If multiple volumes were affected on the failed disk, you might need to run this command for each volume.

7.  **Monitor Recovery:** Use `vxprint -pht -g <diskgroup_name> <volume_name>` and `vxtask list` to monitor the progress of the recovery.

8.  **Remove the Failed Disk Record (Optional but Recommended):** Once the new disk is online and synchronized, you can remove the record of the failed disk (if it still exists in a `failed` state):

    ```bash
    sudo /etc/vx/bin/vxdisk rm <failed_disk_media_name>
    ```

**Important Considerations:**

* **Backup:** Always have a reliable backup of your data before performing any disk replacement procedures.
* **Disk Compatibility:** Ensure the replacement disk is compatible with your hardware in terms of interface, speed, and geometry (ideally identical).
* **Hot-Swapping:** If your hardware supports hot-swapping, you might be able to perform the physical replacement without powering down the system. Consult your hardware documentation.
* **Error Handling:** Pay close attention to the output of all commands for any error messages and troubleshoot accordingly.
* **VxVM Documentation:** Refer to the official Veritas Volume Manager documentation for your specific version for the most detailed and accurate instructions.

Choose the method ( `vxdiskadm` or command-line) that you are most comfortable with. `vxdiskadm` generally simplifies the process and reduces the chance of errors.