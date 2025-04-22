## Links and reference
 * [TecMint](https://www.tecmint.com/upgrade-rhel-8-to-rhel-9/)

The process to upgrade from Red Hat Enterprise Linux (RHEL) 8 to RHEL 9 is an **in-place upgrade** performed using the **Leapp utility**. This method replaces the existing RHEL 8 system with RHEL 9 while preserving installed applications, configurations, and data.

Here's a breakdown of the general steps involved:

**1. Prerequisites and Planning:**

* **Supported Architecture:** Ensure your system has a supported architecture (64-bit Intel, AMD, ARM, IBM POWER (little endian), or IBM Z).
* **Minimum Hardware Requirements:** Verify that your system meets the minimum hardware requirements for RHEL 9.
* **RHEL 8.6 or Later:** The recommended and often required starting point is RHEL 8.6 or a later 8.x release.
* **Active Red Hat Subscription:** Your system needs a valid and active Red Hat subscription with access to both RHEL 8 and RHEL 9 repositories.
* **System Backup:** **Crucially, create a full backup of your system** before starting the upgrade. This could be a snapshot of your virtual machine, a backup to external storage, or any other reliable backup method.
* **Sufficient Disk Space:** Ensure you have enough free space in `/var/lib/leapp/` (at least 2-5 GB is recommended) to accommodate the upgrade process.
* **Network Connectivity:** A stable network connection is required to download packages.
* **Disable Third-Party Repositories:** It's best to disable all third-party repositories before the upgrade to avoid conflicts.
* **Remove Version Lock Plugin:** If you are using the `versionlock` plugin, you need to clear any package locks.
* **SELinux in Permissive Mode:** Set SELinux to permissive mode (`sudo setenforce 0`) before the upgrade. You can re-enable it in enforcing mode after the upgrade.
* **Firewalld Configuration:** Disable `AllowZoneDrifting` in `/etc/firewalld/firewalld.conf` by commenting out the line. Restart `firewalld` after the upgrade.

**2. Preparing the RHEL 8 System:**

* **Update RHEL 8:** Ensure your RHEL 8 system is fully updated to the latest packages:
    ```bash
    sudo dnf update -y
    sudo reboot
    ```
* **Install the Leapp Utility:** Install the `leapp-upgrade` package:
    ```bash
    sudo dnf install leapp-upgrade -y
    ```
    If you are using RHUI on a public cloud (like AWS or Azure), you might need to install additional `leapp-rhui` packages.
* **Set the System Release:** Lock your RHEL 8 system to the specific minor release you are upgrading from (e.g., 8.10):
    ```bash
    sudo subscription-manager release --set 8.10
    ```
    If using RHUI, use `rhui-set-release` or manually edit `/etc/dnf/vars/releasever`.

**3. Pre-Upgrade Phase:**

* **Run the Pre-Upgrade Check:** This crucial step simulates the upgrade and identifies potential issues:
    ```bash
    sudo leapp preupgrade --target 9.4  # Replace 9.4 with your desired RHEL 9 minor release
    ```
    If your system is not registered with RHSM, use `--no-rhsm`.
* **Review the Pre-Upgrade Report:** The `leapp` utility generates a report in `/var/log/leapp/leapp-report.txt` (and in JSON format). Carefully review this report for any inhibitors or warnings. You **must** address all inhibitors before proceeding with the actual upgrade. This might involve removing conflicting packages, adjusting configurations, or other manual interventions.

**4. Performing the Upgrade:**

* **Execute the Upgrade Command:** Once all inhibitors are resolved, start the upgrade process:
    ```bash
    sudo leapp upgrade --target 9.4 # Replace 9.4 with your desired RHEL 9 minor release
    ```
    Again, use `--no-rhsm` if your system is not registered with RHSM.
* **Reboot:** After the upgrade process completes, `leapp` will prompt you to reboot your system. During the reboot, select the `RHEL-Upgrade-Initramfs` option in the GRUB menu. This will continue the upgrade process.

**5. Post-Upgrade Tasks:**

* **Verify the Upgrade:** After the final reboot, log in and verify that the upgrade was successful:
    ```bash
    cat /etc/redhat-release
    uname -a
    ```
* **Update the System:** Run a full update on the newly upgraded RHEL 9 system:
    ```bash
    sudo dnf update -y
    ```
* **Set the Release for RHEL 9:** Set the system release to the RHEL 9 version:
    ```bash
    sudo subscription-manager release --set 9.4 # Replace 9.4 with your actual RHEL 9 version
    ```
* **Re-enable Third-Party Repositories:** If needed, re-enable your third-party repositories, ensuring they are compatible with RHEL 9.
* **Reconfigure SELinux:** If you disabled SELinux, set it back to enforcing mode (`sudo setenforce 1`) and potentially relabel the file system (`sudo fixfiles -B onboot`).
* **Restart Firewalld:** If you modified the `firewalld` configuration, restart the service:
    ```bash
    sudo systemctl restart firewalld
    ```
* **Test Applications and Services:** Thoroughly test all your applications and services to ensure they are functioning correctly on RHEL 9.
* **Review Logs:** Check system logs for any errors or issues after the upgrade.

**Important Considerations:**

* The upgrade process can take a significant amount of time depending on the size of your system and network speed.
* Carefully read and understand the pre-upgrade report. Ignoring inhibitors can lead to a failed upgrade or an unstable system.
* Refer to the official Red Hat documentation for the most up-to-date and detailed instructions: [https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/upgrading_from_rhel_8_to_rhel_9/index](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/upgrading_from_rhel_8_to_rhel_9/index)

This detailed explanation should provide you with a comprehensive understanding of the RHEL 8 to RHEL 9 upgrade process. Remember to proceed with caution and always back up your data before performing a major system upgrade.