`vm.swappiness` is a Linux kernel parameter that controls the **tendency of the kernel to move processes out of physical memory (RAM) and onto the swap disk**. It influences how aggressively the system will use swap space.

Think of it as a setting that tells the kernel: "How eager should you be to move inactive stuff from fast RAM to slower disk?"

The value of `vm.swappiness` ranges from **0 to 100**:

* **`vm.swappiness = 0`**: The kernel will **avoid swapping as much as possible**. It will only swap when the amount of free and file-backed (cache) pages is critically low. In essence, it tries to keep as much as possible in RAM.

* **`vm.swappiness = 1` (and other low values):** Since kernel version 3.5, a value of 1 represents the **minimum amount of swapping without disabling it entirely**. The kernel will generally only swap when it's almost out of memory.

* **`vm.swappiness = 60` (default on many distributions like Ubuntu):** This is a **balanced setting**. The kernel will use swap moderately. It will swap out inactive pages even when there is still a reasonable amount of free RAM available.

* **`vm.swappiness = 100`**: The kernel will **aggressively swap out inactive pages** from RAM to the swap disk, even if there is still plenty of free RAM.

**How `vm.swappiness` Affects Performance:**

* **High `swappiness` (e.g., 60-100):**
    * **Pros:** Can help prevent the system from running out of RAM and potentially crashing under heavy memory load. It might also free up RAM for the file system cache, potentially improving disk I/O in some specific scenarios.
    * **Cons:** Can lead to increased disk I/O (swapping in and out), which is much slower than RAM access. This can significantly decrease system responsiveness and application performance, especially for frequently used applications.

* **Low `swappiness` (e.g., 0-20):**
    * **Pros:** Tends to keep more data in RAM, leading to better system responsiveness and faster application performance, as RAM access is much quicker than swap.
    * **Cons:** If the system runs out of physical RAM, it might become very sluggish or even encounter out-of-memory (OOM) killer situations where the kernel terminates processes to free up memory.

**When to Adjust `vm.swappiness`:**

The optimal `vm.swappiness` value depends on your system's workload and the amount of RAM you have:

* **Systems with ample RAM (e.g., 8GB or more) and a focus on responsiveness (like desktop or development machines):** Lowering `vm.swappiness` (e.g., to 10 or even 1) can be beneficial. This encourages the kernel to keep more in RAM and reduces unnecessary swapping.

* **Servers or systems with limited RAM where stability is crucial:** A higher `swappiness` (closer to the default or slightly higher) might be preferred to avoid running out of memory and potentially crashing, even if it means some performance impact due to swapping.

* **Database servers:** Often recommend a low `swappiness` (like 10) to minimize disk I/O and keep database data in RAM for faster access.

**How to Check and Change `vm.swappiness`:**

1.  **Check the current value:**
    ```bash
    cat /proc/sys/vm/swappiness
    ```
    or
    ```bash
    sysctl vm.swappiness
    ```

2.  **Change the value temporarily (will be reset on reboot):**
    ```bash
    sudo sysctl vm.swappiness=<new_value>
    ```
    Replace `<new_value>` with your desired value (e.g., `10`).

3.  **Change the value permanently (across reboots):**
    * Open the `/etc/sysctl.conf` file (or a file in `/etc/sysctl.d/`) with root privileges:
        ```bash
        sudo nano /etc/sysctl.conf
        ```
    * Add or modify the line:
        ```
        vm.swappiness=<new_value>
        ```
    * Save the file and apply the changes:
        ```bash
        sudo sysctl -p
        ```

**Important Considerations:**

* Disabling swap entirely (`vm.swappiness = 0` on older kernels, or no swap partition/file) can be risky. If your system runs out of RAM, it's more likely to crash. A small amount of swap can act as a safety net.
* Experiment with different values and monitor your system's performance to find the optimal setting for your specific use case.
* Changes to `vm.swappiness` are just one aspect of memory management tuning. Other parameters like `vm.vfs_cache_pressure` also play a role.

In summary, `vm.swappiness` is a crucial kernel parameter that influences how aggressively your Linux system uses swap space. Adjusting it can impact system responsiveness and stability, and the optimal value depends on your system's resources and workload.