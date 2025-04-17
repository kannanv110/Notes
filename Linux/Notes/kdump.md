## What is Kdump?

**Kdump** is a feature of the Linux kernel that creates **crash dumps** (also known as vmcore) in the event of a kernel crash (panic). When the kernel encounters a fatal error, instead of immediately halting or rebooting, kdump uses the **kexec** system call to boot into a **second, minimal kernel** (often called the "capture kernel") that resides in a pre-allocated and reserved area of memory.

This second kernel then captures the memory image of the crashed primary kernel and saves it to a persistent storage location (local disk, remote server via NFS or SSH, or a raw device). This memory dump contains valuable information about the state of the system at the time of the crash, which can be analyzed later by developers and system administrators to **debug the cause of the kernel panic**.

**Key Benefits of Kdump:**

* **Reliable Crash Dump Capture:** Because the dump is captured by a separate, freshly booted kernel from a reserved memory region, it avoids relying on the potentially corrupted primary kernel.
* **Preserves Crash State:** The memory of the crashed kernel is preserved during the boot of the capture kernel, ensuring accurate data for analysis.
* **Non-Disruptive (mostly):** Kdump aims to minimize downtime by quickly booting into the capture kernel and then rebooting the system to a normal state after the dump is saved.
* **Valuable for Debugging:** The captured memory dump (`vmcore` file) can be analyzed using tools like `gdb` with kernel debugging symbols or specialized crash analysis utilities to pinpoint the root cause of kernel panics.

## How to Configure Kdump:

The configuration process for kdump typically involves these steps:

**1. Install Necessary Packages:**

   You'll usually need the `kexec-tools` package (or similar, depending on your distribution). This package contains the `kdump` service and related utilities.

   ```bash
   # For Debian/Ubuntu
   sudo apt-get update
   sudo apt-get install kexec-tools

   # For Red Hat/CentOS/Fedora
   sudo yum install kexec-tools
   # OR
   sudo dnf install kexec-tools

   # For SUSE
   sudo zypper install kexec-tools
   ```

**2. Reserve Memory for the Kdump Kernel:**

   A dedicated portion of RAM needs to be reserved for the capture kernel to load into. This is done by adding the `crashkernel=` parameter to the kernel boot command line.

   * **Edit Bootloader Configuration:** Modify your bootloader configuration file (usually `/etc/default/grub` for GRUB). Find the line starting with `GRUB_CMDLINE_LINUX` and append the `crashkernel=` parameter.

      * **Automatic Memory Allocation (`crashkernel=auto`):** This is often the easiest option, where the system automatically determines a suitable amount of memory to reserve based on the total RAM.

         ```bash
         GRUB_CMDLINE_LINUX="... crashkernel=auto"
         ```

      * **Manual Memory Allocation (`crashkernel=<size>[@<offset>]`):** You can specify a fixed amount of memory to reserve. The size is in megabytes (M) or gigabytes (G). Optionally, you can specify an offset for the reserved region.

         ```bash
         GRUB_CMDLINE_LINUX="... crashkernel=512M"   # Reserve 512 MB
         GRUB_CMDLINE_LINUX="... crashkernel=1G@16M" # Reserve 1 GB starting at offset 16 MB
         ```

   * **Update Bootloader Configuration:** After editing the file, update the bootloader configuration:

      ```bash
      # For Debian/Ubuntu
      sudo update-grub

      # For Red Hat/CentOS/Fedora (using GRUB2)
      sudo grub2-mkconfig -o /boot/grub2/grub.cfg

      # For older systems using GRUB (GRUB Legacy)
      sudo grub-mkconfig -o /boot/grub/menu.lst
      ```

**3. Configure Kdump Saving Target:**

   The `/etc/kdump.conf` file is the primary configuration file for the `kdump` service. You need to specify where the `vmcore` file should be saved. Common options include:

   * **Local Filesystem (`path <directory>`):** Save the dump to a local directory. Ensure the directory has enough free space (typically the size of your RAM + a bit more).

      ```
      path /var/crash
      ```

   * **Raw Device (`raw <device>`):** Write the dump directly to a raw block device.

      ```
      raw /dev/sdb1
      ```

   * **NFS Mount (`nfs <server>:<path>`):** Save the dump to a remote server via NFS.

      ```
      nfs your_nfs_server:/var/crash_dumps
      ```

   * **SSH (`ssh <user>@<host> [options]`):** Save the dump to a remote server via SSH. You might need to configure SSH key-based authentication.

      ```
      ssh root@your_ssh_server
      sshkey /root/.ssh/id_rsa
      path /var/crash_dumps
      ```

   You can also configure other options in `/etc/kdump.conf`, such as:

   * **`core_collector`:** Specifies the tool used to collect the core dump (usually `makedumpfile`).
   * **`default <action>`:** Defines the action to take if the dump fails (e.g., `reboot`, `halt`, `poweroff`).
   * **`filter`:** Controls which memory pages are included in the dump (to reduce size).

**4. Enable and Start the Kdump Service:**

   Enable and start the `kdump` service using `systemctl` (or the appropriate service management tool for your distribution).

   ```bash
   # Using systemctl (most modern distributions)
   sudo systemctl enable kdump.service
   sudo systemctl start kdump.service

   # Using service command (older distributions)
   sudo service kdump enable
   sudo service kdump start
   ```

**5. Verify Kdump Status:**

   Check if the `kdump` service is running:

   ```bash
   sudo systemctl status kdump.service
   # OR
   sudo service kdump status
   ```

   You should see output indicating that the service is active (running).

**6. Test Kdump (Important!):**

   It's crucial to test your kdump configuration to ensure it's working correctly. **This will intentionally crash your kernel, so do this on a non-production system or during a scheduled maintenance window.**

   There are a few ways to trigger a kernel panic:

   * **Using SysRq (Magic SysRq Key):** If enabled, you can trigger a panic from the console:

      ```bash
      echo 1 > /proc/sys/kernel/sysrq
      echo c > /proc/sysrq-trigger
      ```

   * **Causing a Kernel Oops:** You might be able to trigger a less severe kernel oops that sometimes leads to a panic. This is more risky and less predictable for testing.

   After triggering the panic, the system should reboot, and the `vmcore` file should be saved to the location you configured in `/etc/kdump.conf`. Check that the file exists and has a reasonable size (close to the amount of RAM you have).

**7. Analyze the Crash Dump:**

   To analyze the `vmcore` file, you'll typically need:

   * **Kernel Debugging Symbols:** These are separate packages that contain debugging information for your kernel. Install the appropriate `kernel-debuginfo` or similar package for your distribution and kernel version.
   * **Crash Analysis Tools:** The `crash` utility is a powerful tool for interactive post-mortem analysis of kernel crash dumps. Install it using your distribution's package manager.

   ```bash
   # For Debian/Ubuntu
   sudo apt-get install linux-crashdump crash kdump-tools

   # For Red Hat/CentOS/Fedora
   sudo yum install crash kernel-debuginfo

   # For SUSE
   sudo zypper install crash kernel-debuginfo
   ```

   You can then analyze the `vmcore` file using the `crash` command:

   ```bash
   sudo crash /usr/lib/debug/boot/vmlinux-<version>-<arch> /var/crash/vmcore.<timestamp>
   ```

   Replace `/usr/lib/debug/boot/vmlinux-...` with the path to your kernel's debug symbols and `/var/crash/vmcore...` with the path to your `vmcore` file.

**Important Considerations:**

* **Memory Reservation:** The `crashkernel=` value needs to be large enough to load the capture kernel but small enough not to significantly impact the primary kernel's available memory. The `auto` option usually works well.
* **Disk Space:** Ensure the target location for saving the `vmcore` has sufficient free space.
* **Security:** If saving dumps remotely via SSH, ensure proper security measures (key-based authentication, restricted user access) are in place.
* **Kernel Debug Symbols:** Installing the correct kernel debug symbols matching your running kernel is crucial for meaningful crash analysis.
* **Testing:** Always test your kdump configuration after making changes.

By following these steps, you can effectively configure kdump on your Linux system to capture valuable information in the event of a kernel crash, aiding in debugging and preventing future occurrences.