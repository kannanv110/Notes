**UEFI (Unified Extensible Firmware Interface)** is a modern firmware interface that replaces the traditional **BIOS (Basic Input/Output System)** on computers. It's a specification that defines the software interface between a computer's hardware and its operating system. Think of it as a mini-operating system that initializes the hardware during startup and provides services for the operating system to boot.

**Key features and advantages of UEFI over BIOS:**

* **Modern Interface:** UEFI typically offers a graphical user interface (GUI) with mouse support, making it more user-friendly than the text-based BIOS.
* **Larger Disk Support:** UEFI supports the GUID Partition Table (GPT) scheme, which allows for disks larger than 2TB and more than four primary partitions, overcoming the limitations of BIOS's Master Boot Record (MBR).
* **Faster Boot Times:** UEFI can often boot systems faster than BIOS due to optimized initialization processes.
* **Secure Boot:** A key security feature of UEFI, Secure Boot verifies the digital signatures of bootloaders and operating system components to prevent unauthorized software from running during startup.
* **Network Support:** Some UEFI implementations include network capabilities, allowing for remote diagnostics and even network booting.
* **Extensibility:** The "Extensible" in UEFI means it can be expanded with additional functions and drivers.

**How Linux Boots from UEFI:**

When a Linux system boots from UEFI, the process generally follows these steps:

1.  **Power-On Self-Test (POST) and UEFI Initialization:** When the computer is powered on, the UEFI firmware performs a POST to check the hardware components (CPU, memory, etc.). Then, the UEFI firmware itself initializes.
2.  **Hardware Detection:** UEFI detects and initializes other hardware components like storage devices and network cards.
3.  **Boot Manager:** UEFI has its own boot manager, which reads boot configuration variables stored in non-volatile memory (NVRAM). These variables specify the boot order and the location of boot loaders.
4.  **EFI System Partition (ESP):** UEFI looks for a FAT32-formatted partition with a specific GUID, known as the ESP. This partition contains **EFI applications**, including boot loaders for the installed operating systems (like GRUB, systemd-boot, or rEFInd) and other EFI utilities.
5.  **Boot Loader Loading:** The UEFI boot manager loads the boot loader specified in the boot configuration (usually the first one in the boot order) from the ESP into memory and executes it. For Linux, common boot loaders are GRUB (GRand Unified Bootloader) or systemd-boot.
6.  **Kernel Loading:** The Linux boot loader (e.g., GRUB) then reads the Linux kernel image (`vmlinuz`) and the initial RAM disk image (`initramfs` or `initrd`) from the `/boot` partition (which might be on the ESP or a separate partition). These files are loaded into memory.
7.  **Kernel Execution:** The boot loader passes control to the Linux kernel, along with boot parameters and the location of the `initramfs`.
8.  **Initial Ramdisk (initramfs):** The kernel mounts the `initramfs`, a temporary file system in memory that contains essential drivers and utilities needed for the early stages of boot, such as loading necessary kernel modules for accessing the root file system.
9.  **Root File System Mount:** The kernel uses the information in the boot parameters and the `initramfs` to locate and mount the actual root file system.
10. **`init` Process:** Once the root file system is mounted, the kernel executes the `init` process (or systemd, which often replaces init), which becomes the first process with PID 1.
11. **System Startup:** The `init` process then starts the rest of the system services, bringing the Linux system to a fully operational state.

In essence, with UEFI, the firmware is more intelligent and can directly understand file systems, allowing it to load boot loaders as EFI applications from a dedicated partition. This is a significant departure from the BIOS method, which relied on a small boot sector on the hard drive to start the boot process.