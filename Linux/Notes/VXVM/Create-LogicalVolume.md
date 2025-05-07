## Create VxVM Logical Volume
To create a logical volume on a Veritas Volume Manager (VxVM) disk group in Linux, you use the `vxassist` command. Here's the basic syntax and common options:

```bash
sudo /etc/vx/bin/vxassist -g <diskgroup_name> make <volume_name> <size> [layout=<layout_type>] [disk=<disk_name>...]
```

Let's break down the command and its options:

* **`sudo /etc/vx/bin/vxassist`**: The path to the `vxassist` command, which is used for creating and managing Veritas volumes. You'll likely need `sudo` for permissions.
* **`-g <diskgroup_name>`**: Specifies the disk group where you want to create the logical volume (e.g., `datavg`).
* **`make`**: The keyword indicating that you want to create a new volume.
* **`<volume_name>`**: The name you want to assign to your logical volume (e.g., `mylvol`).
* **`<size>`**: The size of the logical volume you want to create. You can specify the size in various units (e.g., `10g` for 10 gigabytes, `500m` for 500 megabytes). You can also use keywords like `all` to use all available free space in the disk group.
* **`[layout=<layout_type>]`**: (Optional) Specifies the layout type for the volume. Common layouts include:
    * **`concat` (default)**: Concatenates disk space from one or more disks.
    * **`stripe`**: Stripes data across multiple disks for improved performance (RAID 0). You'll need to specify the number of columns (`ncol`) and stripe width (`width`).
    * **`mirror`**: Creates a mirrored volume for redundancy (RAID 1). You can specify the number of mirrors (`nmirror`).
    * **`raid5`**: Creates a RAID 5 volume for both performance and redundancy (requires at least three disks). You'll need to specify the number of columns (`ncol`) and stripe width (`width`).
* **`[disk=<disk_name>...]`**: (Optional) Specifies the specific disk(s) within the disk group that you want the volume to reside on. If you don't specify disks, VxVM will automatically allocate space from the available disks in the disk group. You use the logical disk names you assigned when adding the disks to the disk group (e.g., `disk01`, `disk02`).

**Examples:**

1.  **Create a 10GB concatenated volume named `mydata` in the disk group `datavg`:**

    ```bash
    sudo /etc/vx/bin/vxassist -g datavg make mydata 10g
    ```

2.  **Create a 500MB striped volume named `fastdata` across two disks (`disk01`, `disk02`) in `datavg` with a default stripe width:**

    ```bash
    sudo /etc/vx/bin/vxassist -g datavg make fastdata 500m layout=stripe disk=disk01 disk=disk02 ncol=2
    ```

3.  **Create a 20GB mirrored volume named `mirrordata` with one mirror in `datavg`:**

    ```bash
    sudo /etc/vx/bin/vxassist -g datavg make mirrordata 20g layout=mirror nmirror=1
    ```

4.  **Create a RAID 5 volume named `raid5data` of 30GB across three disks (`disk01`, `disk02`, `disk03`) in `datavg`:**

    ```bash
    sudo /etc/vx/bin/vxassist -g datavg make raid5data 30g layout=raid5 disk=disk01 disk=disk02 disk=disk03 ncol=3
    ```

5.  **Create a volume named `alldata` using all the remaining free space in the disk group `datavg`:**

    ```bash
    sudo /etc/vx/bin/vxassist -g datavg make alldata all
    ```

**After Creating the Logical Volume:**

Once the `vxassist` command completes successfully, you can:

1.  **Verify the volume:** Use the `vxprint` command to display information about the volume:

    ```bash
    sudo /etc/vx/bin/vxprint -g <diskgroup_name> -v <volume_name>
    ```

2.  **Create a file system on the volume:** Use a standard Linux file system creation tool (e.g., `mkfs.ext4`, `mkfs.xfs`) on the device path of the newly created volume. The device path will typically be under `/dev/vx/dsk/<diskgroup_name>/<volume_name>` (for block access) or `/dev/vx/rdsk/<diskgroup_name>/<volume_name>` (for raw character access).

    ```bash
    sudo mkfs.ext4 /dev/vx/dsk/datavg/mydata
    ```

3.  **Mount the file system:** Create a mount point and mount the file system:

    ```bash
    sudo mkdir /mnt/mydata
    sudo mount /dev/vx/dsk/datavg/mydata /mnt/mydata
    ```

4.  **Make the mount persistent:** Add an entry to `/etc/fstab` to automatically mount the file system on boot.

Remember to consult the Veritas Volume Manager documentation for more advanced options and details on volume layouts and management.