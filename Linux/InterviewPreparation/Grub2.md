## GRUB 2: Brief Notes

GRUB 2 (GRand Unified Bootloader version 2) is a widely used boot loader for Linux and other operating systems. It replaced the older GRUB Legacy and offers significant improvements in terms of features, flexibility, and support for modern hardware and standards.

Here are some key notes about GRUB 2:

**Core Functionality:**

* **Boot Management:** GRUB 2 is the first program that runs when a computer starts. It is responsible for loading the operating system kernel and transferring control to it.
* **Multi-booting:** It allows users to boot multiple operating systems installed on the same machine, presenting a menu at startup to choose which OS to load.
* **Kernel Loading:** GRUB 2 can load the kernel and the initial RAM disk (initramfs) into memory.
* **Boot Options:** It enables users to select different kernel versions, recovery options, and modify kernel parameters at boot time.

**Key Features and Improvements over GRUB Legacy:**

* **Dynamic Configuration:** The main configuration file, `grub.cfg`, is typically generated automatically using tools like `grub-mkconfig` based on scripts in `/etc/grub.d/` and settings in `/etc/default/grub`. **Direct editing of `grub.cfg` is generally discouraged.**
* **Scripting Language:** The configuration file syntax is more like a scripting language, allowing for variables, conditionals, and loops.
* **Module-based Architecture:** GRUB 2 utilizes a modular design, where functionalities like filesystem drivers are loaded dynamically as needed. This makes the core image smaller and more flexible.
* **Improved Device Naming:** Partition numbering starts from 1 instead of 0.
* **Filesystem Support:** GRUB 2 supports a wider range of filesystems, including ext4, HFS+, and NTFS. It can also read files from LVM and RAID devices.
* **Device Discovery:** More reliable ways to find its own files and kernel images on multi-disk systems, using commands like `search` with filesystem labels or UUIDs.
* **UEFI Support:** Full support for Unified Extensible Firmware Interface (UEFI) in addition to traditional BIOS.
* **Graphical Interface:** Supports graphical menus (themes, splash images, fonts).
* **Internationalization:** The GRUB 2 interface can be translated, including menu entry names.
* **Security Features:** Supports password protection for boot menu options and integration with LUKS encrypted partitions.
* **Rescue Mode:** Provides a command-line interface for manual boot configuration and troubleshooting in case of boot failures.

**Important Configuration Files and Tools:**

* `/etc/default/grub`: Main configuration file for GRUB 2 settings (timeout, default OS, kernel parameters, etc.).
* `/etc/grub.d/`: Directory containing scripts that generate the `grub.cfg` file. The order of execution (and thus the order of menu entries) is determined by the numbering of these scripts.
* `/boot/grub/grub.cfg` or `/boot/grub2/grub.cfg`: The main GRUB 2 configuration file. **Do not edit directly.**
* `grub-mkconfig` or `grub2-mkconfig`: Command-line tool to generate the `grub.cfg` file based on the settings in `/etc/default/grub` and the scripts in `/etc/grub.d/`.
* `update-grub`: A distribution-specific wrapper around `grub-mkconfig`.
* `grub-install` or `grub2-install`: Command-line tool to install GRUB 2 onto a boot device (MBR or EFI System Partition).
* `grub-editenv`: Utility to manage GRUB environment variables, which can persist across reboots.
* `grub-set-default`: Sets the default boot entry.
* `grub-reboot`: Sets the default boot entry for the next boot only.

**Boot Process (Simplified):**

1.  **BIOS/UEFI Initialization:** The system firmware performs a power-on self-test (POST) and initializes hardware.
2.  **Boot Device Selection:** The firmware determines the boot device (e.g., hard drive).
3.  **Loading GRUB 2:** The firmware loads the GRUB 2 bootloader from the boot device (typically from the Master Boot Record (MBR) in BIOS systems or the EFI System Partition in UEFI systems).
4.  **GRUB 2 Initialization:** GRUB 2 initializes itself and its modules.
5.  **Loading Configuration:** GRUB 2 loads its configuration file (`grub.cfg`).
6.  **Displaying Menu (if configured):** If a timeout is set and no key is pressed, GRUB 2 displays a boot menu.
7.  **Selecting Boot Entry:** The user can select an operating system or kernel from the menu.
8.  **Loading Kernel and Initramfs:** GRUB 2 loads the selected kernel and the initial RAM disk image into memory.
9.  **Transferring Control:** GRUB 2 transfers control to the loaded kernel, which then proceeds with the operating system startup.

Understanding these basic notes provides a good foundation for working with and troubleshooting GRUB 2. Remember to consult your distribution's documentation for specific instructions and best practices.