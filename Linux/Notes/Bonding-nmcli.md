Configuring network bonding on Linux using `nmcli` (NetworkManager Command Line Interface) is a straightforward process. Here's a step-by-step guide with examples:

**1. Identify the Network Interfaces:**

First, identify the network interfaces you want to include in the bond. You can use the `ip addr show` or `nmcli device status` command:

```bash
ip addr show
```

or

```bash
nmcli device status
```

Note down the names of the Ethernet interfaces (e.g., `eth0`, `eth1`, `enp0s3`, `enp0s8`). These interfaces should ideally be in a disconnected state or unmanaged by NetworkManager before you start bonding them.

**2. Create the Bond Connection:**

Use the `nmcli connection add` command to create a new bond connection. You'll need to specify a connection name, the type as `bond`, and an interface name for the bond (e.g., `bond0`).

```bash
sudo nmcli connection add type bond con-name bond0 ifname bond0
```

* `type bond`: Specifies the connection type as bonding.
* `con-name bond0`: Sets the name of the connection to `bond0`.
* `ifname bond0`: Sets the interface name of the bond to `bond0`.

**3. Configure the Bond Mode and Options:**

You need to set the bonding mode and other options according to your requirements. Common bonding modes include:

* **`balance-rr` (mode 0):** Round-robin policy; transmits packets in sequential order from the first available slave to the last. Provides load balancing and fault tolerance.
* **`active-backup` (mode 1):** Active-backup policy; only one slave in the bond is active. A different slave becomes active if the active slave fails. Provides fault tolerance.
* **`balance-xor` (mode 2):** XOR policy; transmits based on a selected hashing algorithm for destination MAC address. Provides load balancing and fault tolerance.
* **`broadcast` (mode 3):** Broadcast policy; transmits everything on all slave interfaces. Provides fault tolerance.
* **`balance-tlb` (mode 5):** Adaptive transmit load balancing; channel bonding that does not require any special switch support. Provides outbound load balancing and fault tolerance.
* **`balance-alb` (mode 6):** Adaptive load balancing; includes `balance-tlb` plus receive load balancing (ARP negotiation). Requires switch support for ARP monitoring.

Use the `nmcli connection modify` command to set the bond mode and other options (e.g., `miimon` for link monitoring interval in milliseconds).

```bash
sudo nmcli connection modify bond0 bond.options "mode=active-backup,miimon=100"
```

Replace `"mode=active-backup,miimon=100"` with your desired bonding options. You can specify multiple options separated by commas.

**4. Add Slave Interfaces to the Bond:**

Use the `nmcli connection add` command for each Ethernet interface you want to add as a slave to the bond. Specify the type as `ethernet`, the `master` connection as your bond connection (`bond0`), and the `ifname` as the Ethernet interface name.

For `eth0`:

```bash
sudo nmcli connection add type ethernet slave master bond0 con-name bond0-slave-eth0 ifname eth0
```

For `eth1`:

```bash
sudo nmcli connection add type ethernet slave master bond0 con-name bond0-slave-eth1 ifname eth1
```

Replace `eth0` and `eth1` with the actual names of your Ethernet interfaces. You'll create a separate slave connection for each interface.

**5. Bring the Bond Connection Up:**

Enable and activate the bond connection:

```bash
sudo nmcli connection up bond0
```

This will also bring up the slave interfaces associated with the bond.

**6. Configure IP Addressing for the Bond:**

You can configure IP addressing (static or DHCP) for the bond connection (`bond0`).

**For DHCP:**

```bash
sudo nmcli connection modify bond0 ipv4.method auto
sudo nmcli connection modify bond0 ipv6.method auto
sudo nmcli connection up bond0
```

**For Static IP:**

```bash
sudo nmcli connection modify bond0 ipv4.method manual
sudo nmcli connection modify bond0 ipv4.addresses "192.168.1.100/24 192.168.1.1" # IP/mask gateway
sudo nmcli connection modify bond0 ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli connection modify bond0 ipv4.dns-search "yourdomain.com"
sudo nmcli connection modify bond0 ipv6.method ignore # Or configure IPv6 as needed
sudo nmcli connection up bond0
```

Replace the IP address, netmask, gateway, DNS servers, and domain search with your network configuration.

**7. Verify the Bond Configuration:**

You can verify the bond configuration using the `ip addr show bond0` command or `cat /proc/net/bonding/bond0`.

```bash
ip addr show bond0
```

```bash
cat /proc/net/bonding/bond0
```

The output will show the bonding mode, the active slave(s), and the status of the bond.

You can also check the NetworkManager connection details:

```bash
nmcli connection show bond0
nmcli connection show bond0-slave-eth0
nmcli connection show bond0-slave-eth1
```

**8. Make the Configuration Persistent:**

NetworkManager usually makes configurations persistent automatically. You can ensure the bond comes up on boot by enabling the connection:

```bash
sudo nmcli connection up bond0
```

If it's not already active on boot, you might need to explicitly enable it:

```bash
sudo nmcli connection modify bond0 connection.autoconnect yes
```

**Example Scenario (Active-Backup Bonding with DHCP on `eth0` and `eth1`):**

```bash
# Create the bond connection
sudo nmcli connection add type bond con-name bond0 ifname bond0

# Configure active-backup mode and link monitoring
sudo nmcli connection modify bond0 bond.options "mode=active-backup,miimon=100"

# Add eth0 as a slave
sudo nmcli connection add type ethernet slave master bond0 con-name bond0-slave-eth0 ifname eth0

# Add eth1 as a slave
sudo nmcli connection add type ethernet slave master bond0 con-name bond0-slave-eth1 ifname eth1

# Configure DHCP for the bond
sudo nmcli connection modify bond0 ipv4.method auto
sudo nmcli connection modify bond0 ipv6.method auto

# Bring the bond connection up
sudo nmcli connection up bond0

# Verify the configuration
ip addr show bond0
cat /proc/net/bonding/bond0
nmcli connection show bond0
```

Remember to adjust the interface names, bonding mode, options, and IP addressing according to your specific network environment and requirements. Always test the bonding configuration thoroughly to ensure it provides the desired level of redundancy and/or performance.