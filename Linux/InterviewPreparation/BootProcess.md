# Linux Boot Process
The Linux boot process starts with hardware initialization (BIOS/UEFI), followed by bootloader execution (GRUB), kernel loading, and finally, system initialization (init system like systemd) which manages services and brings the system to a usable state. 
Here's a more detailed breakdown of the Linux boot process:
## 1. Hardware Initialization (BIOS/UEFI):
 - When you power on your computer, the BIOS (Basic Input/Output System) or UEFI (Unified Extensible Firmware Interface) firmware is loaded from non-volatile memory.
 - It performs a Power-On Self Test (POST) to check the hardware components.
 - BIOS/UEFI detects and initializes hardware devices, including CPU, RAM, and storage.
 - It then determines the boot device (e.g., hard drive, USB) from which to load the operating system. 
## 2. The Master Boot Record
MBR consists of 512 bytes at the first sector of the hard disk. It is important to note that MBR is not located inside any partition. MBR precedes the first partition. The layout of MBR is as follows:
 - First 446 bytes contain bootable code.
 - Next 64 bytes contain partition information for 4 partitions (16x4). That is why the hard disks can have only 4 primary partitions, as the MBR can store information for 4 partitions only. So if you need more than 4 partitions on the hard disk, one of the primary partition has to be made extended, and out of this extended partition, logical partitions are created.
 - Last 2 bytes are for MBR signature, also called magic number. (Thus total of 446 + 64 + 2 = 512 bytes).
```
|=================|======|======|======|======|===|
| 446             | 16   | 16   | 16   | 16   | 2 |
|=================|======|======|======|======|===|
```
The first 446 bytes of MBR contain the code that locates the partition to boot from. The rest of booting process takes place from that partition. This partition contains a software program for booting the system called the 'bootloader'.
## 3. Bootloader Execution (GRUB):
 - The BIOS/UEFI transfers control to the bootloader, which is typically GRUB (Grand Unified Bootloader).
 - GRUB presents a menu to the user, allowing them to select the operating system or kernel to boot.
 - After selection, GRUB loads the kernel into memory.
### GRUB and the x86 Boot Process
GRUB loads itself into memory in the following stages:
 - The Stage 1 or primary boot loader is read into memory by the BIOS from the MBR. The primary boot loader exists on less than 512 bytes of disk space within the MBR and is capable of loading either the Stage 1.5 or Stage 2 boot loader.
 - The Stage 1.5 boot loader is read into memory by the Stage 1 boot loader, if necessary. Some hardware requires an intermediate step to get to the Stage 2 boot loader. This is sometimes true when the /boot/ partition is above the 1024 cylinder head of the hard drive or when using LBA mode. The Stage 1.5 boot loader is found either on the /boot/ partition or on a small part of the MBR and the /boot/ partition.
 - The Stage 2 or secondary boot loader is read into memory. The secondary boot loader displays the GRUB menu and command environment. This interface allows the user to select which kernel or operating system to boot, pass arguments to the kernel, or look at system parameters.
 - The secondary boot loader reads the operating system or kernel as well as the contents of /boot/sysroot/ into memory. Once GRUB determines which operating system or kernel to start, it loads it into memory and transfers control of the machine to that operating system.
## 4. Kernel Initialization:
 - The Linux kernel is loaded and starts executing.
 - The kernel initializes the system's memory, hardware, and device drivers.
 - It then starts the init process, which is the first user-space process. 
## 5. System Initialization (init system):
 - The init process, like systemd, is responsible for managing the system's startup and shutdown processes.
 - It mounts file systems, starts essential services, and runs startup scripts.
 - The init system then determines the target or runlevel to boot into, which defines the state of the system (e.g., graphical or command-line). 
## 6. User Interaction:
 - After the system is initialized, a login prompt or desktop environment is presented to the user.
 - The user can then log in and interact with the system.
