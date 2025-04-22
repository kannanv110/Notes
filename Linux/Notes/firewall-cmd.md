```bash
sudo firewall-cmd --command [OPTIONS]
```

**Explanation of the main parts:**

* `sudo`: Executes the command with root privileges, necessary for modifying firewall rules.
* `firewall-cmd`: The command-line client for managing `firewalld`.
* `--command`: Specifies the action you want `firewall-cmd` to perform. Common commands include:
    * `--state`: Check if `firewalld` is running.
    * `--get-default-zone`: Display the default zone.
    * `--set-default-zone=<zone>`: Set the default zone.
    * `--get-active-zones`: List currently active zones and their associated interfaces.
    * `--list-all`: Display all settings for the default zone.
    * `--list-all --zone=<zone>`: Display all settings for a specific zone.
    * `--get-zones`: List all available zones.
    * `--get-services`: List all available predefined services.
    * `--list-ports`: List open ports in the default zone.
    * `--list-ports --zone=<zone>`: List open ports in a specific zone.
    * `--add-port=<port>/<protocol> [--permanent]`: Open a specific port (e.g., `80/tcp`, `53/udp`). The `--permanent` option makes the rule persistent across reboots.
    * `--remove-port=<port>/<protocol> [--permanent]`: Close a specific port.
    * `--add-service=<service> [--permanent]`: Allow traffic for a predefined service (e.g., `http`, `ssh`).
    * `--remove-service=<service> [--permanent]`: Disallow traffic for a predefined service.
    * `--add-source=<ip-address> [--permanent]`: Allow traffic from a specific IP address or network.
    * `--remove-source=<ip-address> [--permanent]`: Block traffic from a specific IP address or network.
    * `--reload`: Apply permanent rules to the runtime configuration without interrupting existing connections.
    * `--runtime-to-permanent`: Save the current runtime configuration to the permanent configuration.

* `[OPTIONS]`: Additional parameters for the specified command, such as the zone, port, protocol, or service name.

**Example 1: Check the status of firewalld**

```bash
sudo firewall-cmd --state
```

**Example 2: List all settings for the default zone**

```bash
sudo firewall-cmd --list-all
```

**Example 3: List all available zones**

```bash
sudo firewall-cmd --get-zones
```

**Example 4: Open port 80 (HTTP) for the `public` zone (runtime only)**

```bash
sudo firewall-cmd --zone=public --add-port=80/tcp
```

**Example 5: Open port 443 (HTTPS) for the `public` zone permanently**

```bash
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
```

**Example 6: Allow SSH service (port 22/tcp) for the `work` zone (runtime only)**

```bash
sudo firewall-cmd --zone=work --add-service=ssh
```

**Example 7: Allow HTTP service for the `home` zone permanently**

```bash
sudo firewall-cmd --zone=home --add-service=http --permanent
```

**Example 8: Remove the previously added HTTP service from the `home` zone permanently**

```bash
sudo firewall-cmd --zone=home --remove-service=http --permanent
```

**Example 9: Allow traffic from the IP address `192.168.1.100` for the `trusted` zone (runtime only)**

```bash
sudo firewall-cmd --zone=trusted --add-source=192.168.1.100
```

**Example 10: Reload firewalld to apply permanent rules**

```bash
sudo firewall-cmd --reload
```

**Important Notes:**

* Changes made without the `--permanent` option are only applied to the current runtime configuration and will be lost after a reboot or firewall restart.
* Always use `--permanent` when you want the rules to persist across reboots. You'll usually need to `--reload` the firewall after making permanent changes to apply them to the current runtime as well.
* It's good practice to verify your firewall rules using `--list-ports`, `--list-services`, or `--list-all` after making changes.
* `firewalld` uses the concept of **zones** to manage different trust levels for network interfaces and sources. Understanding zones (e.g., `public`, `private`, `work`, `home`, `trusted`, `dmz`, `block`, `drop`, `external`, `internal`) is crucial for effective firewall management. You can see the default zone with `sudo firewall-cmd --get-default-zone` and active zones with `sudo firewall-cmd --get-active-zones`.

These examples provide a basic understanding of how to use the `firewall-cmd` tool to manage your Linux firewall. For more advanced configurations, refer to the `man firewall-cmd` page.