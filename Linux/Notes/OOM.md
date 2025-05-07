## OOM Kill on Linux: Simple Explanation
## Links and References
 * [Linux OOM Killer: A Detailed Guide to Memory Management](https://last9.io/blog/understanding-the-linux-oom-killer/#:~:text=When%20available%20memory%20and%20swap,excessive%20memory%20to%20free%20up)
 * [How to Configure the Linux Out-of-Memory Killer](https://www.oracle.com/technical-resources/articles/it-infrastructure/dev-oom-killer.html)

**OOM Kill** (Out Of Memory Kill) is a mechanism in the Linux kernel that is invoked when the system is critically **low on memory (RAM)** and needs to free up resources to prevent a complete system crash or instability.

Think of it like this: Imagine a crowded bus (your computer's RAM). If too many people (processes) try to get on, the bus will become dangerously overloaded and could break down. To prevent this, the bus driver (the Linux kernel) has to forcefully remove some passengers (processes) to keep the bus running. This forceful removal is the OOM kill.

**How it Works:**

1. **Memory Pressure:** The kernel constantly monitors the available memory. When it detects that the system is running dangerously low and swapping to disk excessively (which slows things down dramatically), it starts considering the OOM killer.

2. **OOM Score:** The kernel assigns an **"OOM score"** to each running process. This score is a heuristic value that attempts to estimate how "bad" it would be to kill that process. Factors influencing the OOM score include:
   * **Memory Consumption:** Processes using a lot of memory generally have higher scores.
   * **CPU Usage:** Processes using a lot of CPU might be considered more important (though this is less of a primary factor than memory).
   * **Privileges:** Root-owned processes often receive lower (better) scores, making them less likely to be killed.
   * **`oom_score` and `oom_score_adj`:** These are per-process settings that allow administrators (or the system) to influence the OOM score. A negative `oom_score` makes a process less likely to be killed, while a positive value makes it more likely.

3. **Victim Selection:** When the kernel decides to invoke the OOM killer, it scans through the running processes, calculates their OOM scores, and **chooses the process with the highest (worst) OOM score to terminate**.

4. **The "Kill":** The kernel sends a `SIGKILL` signal to the selected process, forcefully terminating it without giving it a chance to gracefully shut down or save its state.

5. **Memory Recovery:** By killing the memory-hungry process, the kernel hopes to free up enough RAM to allow the rest of the system to continue functioning.

**Why Does OOM Kill Happen?**

* **Memory Leaks:** A program might have a bug that causes it to allocate memory without ever releasing it, gradually consuming all available RAM.
* **Resource Exhaustion:** Too many memory-intensive applications running simultaneously can overwhelm the system's RAM.
* **Configuration Issues:** Incorrectly configured applications or system settings might lead to excessive memory usage.

**Consequences of OOM Kill:**

* **Data Loss:** The killed process is terminated abruptly, meaning any unsaved data is likely lost.
* **Service Interruption:** If a critical service or application is killed, it will become unavailable until it is restarted.
* **System Instability (in severe cases):** While OOM kill is meant to prevent a complete crash, frequent OOM kills can indicate a persistent memory pressure issue that needs to be addressed.

**In summary, OOM kill is a last-resort mechanism in Linux to prevent catastrophic system failure due to extreme memory exhaustion by forcefully terminating the process deemed most expendable based on its OOM score.** It's a sign that your system is under significant memory pressure and you should investigate the cause.

You can't directly *start* a process with a specific OOM (Out-of-Memory) score. The OOM killer is a mechanism in the Linux kernel that *chooses* which processes to terminate when the system is critically low on memory. The OOM score of a process is calculated dynamically by the kernel based on various factors, making some processes more likely to be killed than others.

However, you can influence the OOM score of a process when you *start* it, which in turn affects its likelihood of being killed by the OOM killer in a low-memory situation. You do this by adjusting the **oom_score_adj** value for the process.

**Understanding `oom_score` and `oom_score_adj`:**

* **`oom_score`**: This is a value calculated by the kernel for each running process. A higher `oom_score` indicates that the process is a more likely candidate to be killed by the OOM killer. The score is influenced by factors like the process's memory usage, CPU usage, privileges (root processes generally have lower scores), and whether it's recently accessed memory. You can view a process's current `oom_score` by reading the `/proc/[PID]/oom_score` file.

* **`oom_score_adj`**: This is a user-adjustable value that you can set for a process. It's an integer between -1000 and +1000. This value is added to the kernel's internal `oom_score` calculation.
    * A negative `oom_score_adj` makes the process *less* likely to be killed. A value of -1000 effectively disables OOM killing for that process (use with extreme caution!).
    * A positive `oom_score_adj` makes the process *more* likely to be killed.

**How to Start a Process and Influence its OOM Score:**

You can set the `oom_score_adj` value for a process when you start it using the `nice` command (which primarily affects CPU scheduling priority) in combination with shell redirection to write to the process's `oom_score_adj` file *after* it has started.

Here's the general approach:

1.  **Start the process in the background:** This allows you to get its PID.
2.  **Get the PID of the newly started process.**
3.  **Use `sudo` and `echo` to write the desired `oom_score_adj` value to the `/proc/[PID]/oom_score_adj` file.**

**Example:**

Let's say you want to start a CPU-intensive process (e.g., `stress-ng`) and make it less likely to be killed by the OOM killer by setting its `oom_score_adj` to -500.

```bash
# Start the process in the background
stress-ng --cpu 4 --timeout 3600 &
process_pid=$!

# Get the PID of the last background command
echo "Process PID: $process_pid"

# Set the oom_score_adj value for the process
if [ -n "$process_pid" ]; then
  sudo sh -c "echo -500 > /proc/$process_pid/oom_score_adj"
  cat /proc/$process_pid/oom_score_adj # Verify the value
fi
```

**Explanation:**

* `stress-ng --cpu 4 --timeout 3600 &`: This command starts the `stress-ng` tool to stress the CPU on 4 cores for an hour and runs it in the background (`&`).
* `process_pid=$!`: The `$!` special variable in Bash holds the process ID of the last command run in the background.
* `echo "Process PID: $process_pid"`: This displays the PID of the `stress-ng` process.
* `if [ -n "$process_pid" ]; then ... fi`: This ensures that a PID was successfully captured.
* `sudo sh -c "echo -500 > /proc/$process_pid/oom_score_adj"`: This is the crucial part.
    * We use `sudo` because writing to `/proc/[PID]/oom_score_adj` requires root privileges.
    * `sh -c "..."`: This executes the command within a subshell to handle the redirection correctly with `sudo`.
    * `echo -500 > /proc/$process_pid/oom_score_adj`: This writes the value `-500` to the `oom_score_adj` file of the specified process.
* `cat /proc/$process_pid/oom_score_adj`: This reads and displays the current `oom_score_adj` value for the process to verify that it has been set correctly.

**Important Notes:**

* **Root Privileges:** Modifying `oom_score_adj` requires root privileges (`sudo`).
* **Timing:** You need to set the `oom_score_adj` *after* the process has started and its PID has been assigned.
* **Persistence:** The `oom_score_adj` value is specific to the running instance of the process. If the process restarts, you'll need to set the value again. To make this persistent for a service, you might need to configure it within the service's unit file (for systemd) or its init script.
* **Extreme Values:** Setting `oom_score_adj` to -1000 makes a process very unlikely to be killed, even in severe OOM situations. Use this with caution, as it could lead to the OOM killer terminating other critical system processes instead.
* **Monitoring:** You can monitor the `oom_score` of a process using `cat /proc/[PID]/oom_score`. You'll likely see it change based on system memory pressure and the `oom_score_adj` you've set.

By using this method, you can influence the OOM score of a process when you start it, making it more or less likely to be targeted by the OOM killer during memory shortages. Remember to understand the implications of adjusting this value for your system's stability.