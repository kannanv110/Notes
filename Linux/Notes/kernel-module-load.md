There are several ways to load Linux kernel modules at boot time. The best method depends on your distribution and how you want to manage the modules. Here are the common approaches:

**1. Using `/etc/modules` (Traditional Method - Works on many distributions):**

This is a simple and widely supported method. You list the modules you want to load at boot, one per line, in the `/etc/modules` file.

* **Edit `/etc/modules`:** Open the file with root privileges using a text editor (like `nano` or `vim`).

    ```bash
    sudo nano /etc/modules
    ```

* **Add Module Names:** Add the names of the kernel modules you want to load, one per line. For example, to load the `vcan` and `can-raw` modules:

    ```
    vcan
    can-raw
    ```

* **Save and Exit:** Save the changes to the file and exit the editor.

* **Reboot:** The specified modules will be loaded automatically during the next system boot.

**2. Using `systemd-modules-load.service` (Modern Method - Systemd-based distributions like Fedora, Ubuntu, CentOS 7/8/9, etc.):**

Systemd provides a dedicated service for loading kernel modules at boot. You configure the modules in a separate configuration file.

* **Create or Edit Configuration File:** Create or edit a `.conf` file in the `/etc/modules-load.d/` directory. You can name the file as you like (e.g., `mymodules.conf`).

    ```bash
    sudo nano /etc/modules-load.d/mymodules.conf
    ```

* **Add Module Names:** Add the names of the kernel modules you want to load, one per line, in this file. For example:

    ```
    vcan
    can-raw
    ```

* **Save and Exit:** Save the changes and exit the editor.

* **Enable and Start the Service (if not already):** The `systemd-modules-load.service` is usually enabled by default. You can check its status and enable/start it if needed:

    ```bash
    sudo systemctl status systemd-modules-load.service
    sudo systemctl enable systemd-modules-load.service
    sudo systemctl start systemd-modules-load.service
    ```

* **Reboot:** The specified modules will be loaded during the next boot.

**3. Using Distribution-Specific Configuration Files (Less Common):**

Some distributions might have their own specific ways to manage kernel modules at boot. Consult your distribution's documentation for details. Examples might include configuration files in `/etc/sysconfig/` or other system configuration directories.

**4. Loading Modules with Options:**

If you need to load a module with specific options, you'll typically use a separate configuration file in `/etc/modprobe.d/`.

* **Create or Edit Configuration File:** Create or edit a `.conf` file in the `/etc/modprobe.d/` directory (e.g., `vcan.conf`).

    ```bash
    sudo nano /etc/modprobe.d/vcan.conf
    ```

* **Specify Module Options:** Use the `options` directive followed by the module name and its options. For example, to load the `can` module with specific bitrate settings:

    ```
    options can bitrate=1000000
    ```

* **Load the Module at Boot:** Ensure the module name (`can` in this example) is also listed in `/etc/modules` or a file in `/etc/modules-load.d/` to be loaded at boot.

* **Save and Exit, Reboot:** Save the changes and reboot the system.

**Which Method to Choose:**

* For simple loading of modules without options, **`/etc/modules`** is often sufficient and widely compatible.
* For systemd-based distributions, using **`/etc/modules-load.d/`** is the more modern and recommended approach. It helps organize module loading configurations.
* Use **`/etc/modprobe.d/`** to specify options for kernel modules, regardless of how the module is loaded at boot.

**Important Considerations:**

* **Module Name:** Ensure you are using the correct name of the kernel module file (without the `.ko` extension). You can find the available module files in `/lib/modules/$(uname -r)/kernel/`.
* **Dependencies:** If a module depends on other modules, make sure those dependencies are loaded first. The kernel usually handles dependencies automatically, but in some complex cases, you might need to load them in a specific order.
* **Error Checking:** After rebooting, check the system logs (e.g., using `journalctl -b`) to see if the modules were loaded successfully and if there were any errors.
* **Unloading Modules:** To prevent a module from loading at boot, simply remove its entry from `/etc/modules` or the relevant file in `/etc/modules-load.d/`. You can unload a currently loaded module using the `rmmod` command (with caution, as it can affect system stability if the module is in use).

By following these steps, you can reliably configure Linux to load specific kernel modules automatically each time your system boots. Remember to consult your distribution's documentation for any specific recommendations or variations in these methods.