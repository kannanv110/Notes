## Simple Notes about SELinux

SELinux (Security-Enhanced Linux) is a **security enhancement to the Linux kernel** that provides a **Mandatory Access Control (MAC)** system. Unlike traditional Discretionary Access Control (DAC) where users control permissions, SELinux enforces security policies defined by the system administrator.

**Key Concepts:**

* **Security Contexts (Labels):** SELinux labels every process, file, directory, socket, and other system objects with a security context. This context contains information about the user, role, type, and sometimes a security level.
* **Policy:** The SELinux policy is a set of rules that define how processes with certain security contexts can interact with objects having other security contexts. It dictates what actions are allowed or denied.
* **Type Enforcement:** This is the core of the targeted policy (the most common policy). It defines rules based on the **types** of subjects (processes) and objects (files, etc.). For example, a web server process (type `httpd_t`) might be allowed to read files of type `httpd_sys_content_t` but not files of type `shadow_t`.
* **Booleans:** These are on/off switches within the SELinux policy that allow administrators to make runtime adjustments to the policy without needing to recompile it. They control specific behaviors (e.g., allowing HTTPD to connect to the network).
* **Modes:** SELinux can operate in three modes:
    * **Enforcing:** SELinux actively enforces the policy, denying actions that violate the rules and logging them. This is the recommended mode for production systems.
    * **Permissive:** SELinux does not deny any actions but logs violations. This mode is useful for troubleshooting and policy development.
    * **Disabled:** SELinux is completely turned off. No policy is loaded or enforced. This is generally not recommended as it removes the security benefits of SELinux.
* **Targeted Policy:** The default policy in many distributions. It focuses on confining commonly targeted network-facing services (like web servers, SSH daemons) while leaving most user processes unconfined.
* **Full (Strict) Policy:** A more comprehensive policy that aims to confine all processes. It offers higher security but requires more complex configuration and can be more restrictive.

## Common SELinux Management Commands:

Here are some essential commands to manage SELinux:

**1. Checking SELinux Status:**

* `getenforce`: Displays the current SELinux mode (`Enforcing`, `Permissive`, or `Disabled`).
* `sestatus`: Provides a more detailed overview of the SELinux status, including whether it's enabled, the current mode, the policy loaded, and more.
* `cat /etc/selinux/config`: Shows the SELinux configuration file, indicating the mode that will be used on the next boot.

**2. Changing SELinux Mode:**

* `setenforce <0|1>`: Temporarily changes the SELinux mode. `0` for Permissive, `1` for Enforcing. Changes are lost on reboot.
* Edit `/etc/selinux/config`: To permanently change the SELinux mode, modify the `SELINUX` variable (to `enforcing`, `permissive`, or `disabled`) and then reboot the system.

**3. Managing File Contexts:**

* `ls -Z <file|directory>`: Displays the SELinux security context of files and directories.
* `chcon [options] <file|directory>`: Temporarily changes the SELinux security context of files or directories. Changes are not persistent across reboots. Common options include:
    * `-t <type>`: Change the type.
    * `-u <user>`: Change the user.
    * `-r <role>`: Change the role.
    * `-R`: Apply changes recursively.
* `restorecon [options] <file|directory>`: Restores the default SELinux security context of files or directories based on the system's file context configuration. This is used to correct labels after changes. Common options include:
    * `-v`: Verbose output.
    * `-R`: Apply recursively.
    * `-F`: Force relabeling even if the context seems correct.
* `semanage fcontext -l`: Lists the default file context definitions.
* `semanage fcontext -a -t <type> '<path>(/.*)?'`: Adds a new default file context rule for the specified path and type.
* `semanage fcontext -m -t <type> '<path>(/.*)?'`: Modifies an existing default file context rule.
* `semanage fcontext -d '<path>(/.*)?'`: Deletes a default file context rule.
* `touch /.autorelabel`: Forces a complete relabeling of the entire filesystem on the next reboot. Use with caution as it can take a long time.

**4. Managing SELinux Booleans:**

* `getsebool -a`: Lists all SELinux booleans and their current status (on or off).
* `getsebool <boolean_name>`: Displays the status of a specific boolean.
* `setsebool [-P] <boolean_name> <0|1|on|off>`: Changes the state of a boolean.
    * Without `-P`: The change is temporary and will be lost on reboot.
    * With `-P`: The change is persistent across reboots.
* `semanage boolean -l`: Lists all booleans with their current and default states.
* `semanage boolean -m --on <boolean_name>`: Permanently enables a boolean.
* `semanage boolean -m --off <boolean_name>`: Permanently disables a boolean.

**5. Troubleshooting SELinux Issues:**

* `audit2allow -w -a`: Reads the audit log and suggests SELinux policy rules to allow denied actions. Useful for creating custom policies.
* `audit2allow -m <module_name> -a`: Creates a loadable SELinux policy module based on the audit log.
* `sealert -a /var/log/audit/audit.log`: Analyzes the audit log and provides explanations and potential solutions for SELinux denials.
* Check `/var/log/audit/audit.log`: Contains detailed records of SELinux denials and other audit events.

Understanding these basic concepts and commands will help you manage and troubleshoot SELinux on your Linux systems. Remember that SELinux is a powerful security tool, and while it can sometimes seem restrictive, it significantly enhances the security posture of your system when configured correctly.