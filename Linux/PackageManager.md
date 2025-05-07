# Linux Package Manager

## Links and reference
 * [yum-dnf-common-issues](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/linux/yum-dnf-common-issues?tabs=rhel89%2Crhel)
## YUM (Yellowdog Updater, Modified)
The YUM (Yellowdog Updater, Modified) package manager offers several significant advantages for managing software on RPM-based Linux distributions:

**1. Automatic Dependency Resolution:**
   - This is arguably the most crucial advantage. When you want to install, update, or remove a package, YUM automatically identifies and handles all the necessary dependencies (other packages required for the target package to function correctly).
   - It fetches and installs missing dependencies and ensures that removing a package doesn't break other software relying on it. This eliminates the manual and often complex process of tracking and installing dependencies yourself.

**2. Simplified Package Management:**
   - YUM provides a user-friendly command-line interface that simplifies common package management tasks.
   - Installing, updating, and removing packages can be done with simple commands like `yum install <package_name>`, `yum update <package_name>`, and `yum remove <package_name>`.

**3. Working with Repositories:**
   - YUM utilizes software repositories (repos), which are centralized locations containing collections of packages and their metadata.
   - This makes it easy to discover and install a wide range of software from trusted sources (official distribution repos or third-party repos).
   - Managing repositories (adding, enabling, disabling) is straightforward using YUM configuration files.

**4. System-Wide Updates:**
   - YUM allows you to easily update all installed packages on your system to their latest available versions with a single command (`yum update`).
   - This helps keep your system secure and ensures you have the latest features and bug fixes.

**5. Package Searching:**
   - You can search for packages based on keywords in their name or description using the `yum search <keyword>` command. This helps you find the software you need without knowing the exact package name.

**6. Package Information:**
   - YUM can display detailed information about packages, including their name, version, size, description, dependencies, and the repository they belong to (`yum info <package_name>`).

**7. Package Groups:**
   - YUM supports the concept of package groups, which are logical collections of related packages (e.g., "Development Tools"). You can install or uninstall entire groups with a single command (`yum groupinstall <group_name>`, `yum groupremove <group_name>`).

**8. Transaction History:**
   - YUM keeps a detailed history of all package management operations. This allows you to review past actions, undo specific transactions, or even redo them if necessary (`yum history`).

**9. Plugin Support:**
   - YUM has a plugin architecture that allows extending its functionality with additional features. Several useful plugins are available to enhance download speeds, manage priorities, and more.

**10. GPG Signature Verification:**
    - YUM supports GPG (GNU Privacy Guard) signature checking. When enabled (which is highly recommended), YUM verifies that the packages you are installing come from a trusted source and haven't been tampered with.

**11. Caching:**
    - YUM caches downloaded package headers and packages locally. This speeds up subsequent operations, especially when updating or reinstalling packages.

**12. Rollback Capabilities (via History):**
    - As mentioned earlier, the transaction history allows you to revert your system to a previous state if a package installation or update causes issues.

In essence, YUM streamlines the process of managing software on Linux systems, making it more efficient, reliable, and secure compared to manually handling individual RPM files and their dependencies.

The **YUM (Yellowdog Updater, Modified)** package manager is a command-line tool used on RPM-based Linux distributions (like CentOS, Fedora, and Red Hat Enterprise Linux) to manage software packages. It simplifies the process of installing, updating, removing, and searching for software by automatically handling dependencies and working with software repositories.

Here's an explanation of important files and their locations related to YUM:

**1. `/etc/yum.conf`:**

* **Location:** `/etc/yum.conf`
* **Purpose:** This is the **main configuration file** for YUM. It defines global settings that affect how YUM operates.
* **Key Settings:**
    * `cachedir`: Specifies the directory where YUM stores downloaded package headers and packages temporarily. The default is usually `/var/cache/yum/<architecture>/<releasever>`.
    * `keepcache`: Determines whether downloaded packages are kept in the cache directory after installation. The default is `0` (no).
    * `debuglevel`: Sets the debugging output level (0-10).
    * `logfile`: Specifies the log file for YUM activity. The default is `/var/log/yum.log`.
    * `exactarch`: If set to `1`, YUM will only consider packages with a matching architecture.
    * `obsoletes`: If set to `1`, YUM will handle package obsoletes during updates.
    * `gpgcheck`: Globally enables or disables GPG signature checking for packages. It's highly recommended to keep this enabled (`1`).
    * `plugins`: Enables or disables YUM plugins. The default is `0` (disabled).
    * `installonly_limit`: Specifies the number of kernel packages to keep installed.
    * `protected_packages`: Lists packages that YUM should never remove.

**2. `/etc/yum.repos.d/` directory:**

* **Location:** `/etc/yum.repos.d/`
* **Purpose:** This directory contains **repository configuration files** (with the `.repo` extension). Each `.repo` file defines a software repository from which YUM can download and install packages.
* **Structure of a `.repo` file:**
    * `[repository_name]`: The unique name of the repository (e.g., `base`, `epel`).
    * `name`: A human-readable name for the repository.
    * `baseurl`: The URL to the repository's data. This can be an HTTP, FTP, or file URL. You might see variables like `$releasever` and `$basearch` which are automatically substituted.
    * `enabled`: Specifies whether the repository is enabled (`1`) or disabled (`0`).
    * `gpgcheck`: Enables or disables GPG signature checking for packages from this repository (overrides the global setting in `yum.conf`).
    * `gpgkey`: The URL or file path to the GPG public key used to verify package signatures from this repository.

**3. `/var/cache/yum/<architecture>/<releasever>/` directory:**

* **Location:** `/var/cache/yum/<architecture>/<releasever>/` (The exact path might vary slightly based on your system's architecture and release version).
* **Purpose:** This directory serves as the **local cache** for YUM. It stores:
    * **Package headers (metadata):** Information about the packages available in the configured repositories. YUM downloads and caches these headers to quickly determine dependencies and available versions.
    * **Downloaded packages:** When you install or update a package, YUM downloads the RPM file to this directory before installing it. These files are usually deleted after successful installation unless `keepcache=1` is set in `yum.conf` or specified with a command-line option.

**4. `/var/log/yum.log`:**

* **Location:** `/var/log/yum.log`
* **Purpose:** This is the **log file** where YUM records all actions performed, including package installations, updates, removals, and errors.
* **Importance:** This file is crucial for troubleshooting issues, reviewing the history of package management operations, and auditing system changes.

**5. `/var/lib/yum/history/` directory:**

* **Location:** `/var/lib/yum/history/`
* **Purpose:** This directory contains detailed **transaction history** information. YUM records each installation, update, or removal as a transaction, storing details about the packages involved, the time of the operation, and the user who initiated it.
* **Importance:** This history allows you to undo or redo specific YUM transactions, which can be very useful for recovering from accidental removals or problematic updates. You can use the `yum history` command to view and interact with this history.

Understanding these files and their locations is essential for effectively managing software packages on your RPM-based Linux system using the YUM package manager. They provide control over YUM's behavior, define the sources of software, store temporary data, and keep a record of package management activities.
