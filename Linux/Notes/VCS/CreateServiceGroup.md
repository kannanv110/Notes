Okay, let's walk through the commands to configure a service group in Veritas Cluster Server (VCS) on Linux. We'll cover the common steps of creating a service group, adding resources, configuring their attributes, and defining dependencies.

**Assumptions:**

* You have a functioning VCS cluster with LLT and GAB configured and the VCS engine (`had`) running on all nodes.
* You have identified the application or service you want to make highly available and the resources it requires (e.g., IP address, shared storage, application binaries, scripts).
* You know the hostnames of the nodes in your cluster.

**Steps:**

1.  **Create the Service Group:**

    Use the `hagrp -add` command to create a new service group.

    ```bash
    sudo /opt/VRTS/bin/hagrp -add <group_name>
    ```

    Replace `<group_name>` with a descriptive name for your service group (e.g., `web_sg`, `db_sg`, `app_sg`).

    **Example:**

    ```bash
    sudo /opt/VRTS/bin/hagrp -add web_group
    ```

2.  **Add Resources to the Service Group:**

    Use the `hares -add` command to add resources to the newly created service group. You'll need to specify a unique name for each resource, its type, and the group it belongs to.

    ```bash
    sudo /opt/VRTS/bin/hares -add <resource_name> <resource_type> <group_name>
    ```

    Common `<resource_type>` values include:

    * `IP`: For managing virtual IP addresses.
    * `NIC`: For managing network interface cards (though often the IP resource handles this implicitly).
    * `Mount`: For managing shared file system mount points.
    * `DiskGroup`: For managing Veritas Disk Groups.
    * `Volume`: For managing Veritas Volumes.
    * `Application`: For managing custom applications or services using start/stop scripts.
    * `NFSServer`: For managing NFS server resources.
    * `Firewall`: For managing firewall rules.
    * (and many more depending on your VCS agents)

    **Examples (assuming `web_group`):**

    * Adding an IP address resource:

        ```bash
        sudo /opt/VRTS/bin/hares -add web_ip IP web_group
        ```

    * Adding a Mount resource for shared storage:

        ```bash
        sudo /opt/VRTS/bin/hares -add web_mount Mount web_group
        ```

    * Adding a DiskGroup resource:

        ```bash
        sudo /opt/VRTS/bin/hares -add web_dg DiskGroup web_group
        ```

    * Adding an Application resource for the web server:

        ```bash
        sudo /opt/VRTS/bin/hares -add web_app Application web_group
        ```

3.  **Configure Resource Attributes:**

    Use the `hares -modify` command to set the attributes for each resource. The available attributes depend on the resource type. You'll need to consult the VCS agent documentation for the specific resource types you are using.

    ```bash
    sudo /opt/VRTS/bin/hares -modify <resource_name> <attribute_name> <value>
    ```

    **Examples (continuing with `web_group`):**

    * Configuring the `IP` resource (`web_ip`):

        ```bash
        sudo /opt/VRTS/bin/hares -modify web_ip Address <virtual_ip_address>
        sudo /opt/VRTS/bin/hares -modify web_ip NetworkMask <network_mask>
        sudo /opt/VRTS/bin/hares -modify web_ip Device <network_interface> # Public NIC
        ```

    * Configuring the `Mount` resource (`web_mount`):

        ```bash
        sudo /opt/VRTS/bin/hares -modify web_mount MountPoint <mount_point_path>
        sudo /opt/VRTS/bin/hares -modify web_mount BlockDevice <vxvm_volume_path> # e.g., /dev/vx/dsk/web_dg/web_vol
        sudo /opt/VRTS/bin/hares -modify web_mount FsType <file_system_type> # e.g., ext4, xfs
        ```

    * Configuring the `DiskGroup` resource (`web_dg`):

        ```bash
        sudo /opt/VRTS/bin/hares -modify web_dg DiskGroupName <disk_group_name> # e.g., webdg
        ```

    * Configuring the `Application` resource (`web_app`):

        ```bash
        sudo /opt/VRTS/bin/hares -modify web_app StartProgram <start_script_path>
        sudo /opt/VRTS/bin/hares -modify web_app StopProgram <stop_script_path>
        sudo /opt/VRTS/bin/hares -modify web_app MonitorProgram <monitor_script_path>
        sudo /opt/VRTS/bin/hares -modify web_app MonitorInterval <monitoring_interval> # in seconds
        ```

4.  **Define Resource Dependencies:**

    Use the `hares -link` command to establish the order in which resources should come online and go offline within the service group. Resources that depend on others should be linked as children.

    ```bash
    sudo /opt/VRTS/bin/hares -link <parent_resource> <child_resource>
    ```

    **Examples (`web_group` dependencies):**

    * The `IP` address should come online before the `Mount` point:

        ```bash
        sudo /opt/VRTS/bin/hares -link web_ip web_mount
        ```

    * The `Mount` point should come online before the `Application`:

        ```bash
        sudo /opt/VRTS/bin/hares -link web_mount web_app
        ```

    * If using a `DiskGroup`, it should come online before the `Volume` (if a separate Volume resource is used) and the `Mount` point:

        ```bash
        sudo /opt/VRTS/bin/hares -link web_dg web_mount
        # Or if a Volume resource 'web_vol' exists:
        # sudo /opt/VRTS/bin/hares -link web_dg web_vol
        # sudo /opt/VRTS/bin/hares -link web_vol web_mount
        ```

5.  **Define Service Group Dependencies (if needed):**

    If your application relies on other service groups, you can define dependencies between them using `hagrp -link`.

    ```bash
    sudo /opt/VRTS/bin/hagrp -link <parent_group> <child_group>
    ```

6.  **Enable the Service Group for Management:**

    Use `hagrp -enable` to allow VCS to manage the service group.

    ```bash
    sudo /opt/VRTS/bin/hagrp -enable <group_name>
    ```

7.  **Bring the Service Group Online:**

    Use `hagrp -online` to bring the service group and its resources online on a specific node.

    ```bash
    sudo /opt/VRTS/bin/hagrp -online <group_name> -sys <node_hostname>
    ```

    Replace `<node_hostname>` with the hostname of the node where you want to initially bring the group online.

    **Example:**

    ```bash
    sudo /opt/VRTS/bin/hagrp -online web_group -sys node1
    ```

8.  **Verify the Status:**

    Use `hastatus -sum` to check the status of the service group and its resources. All resources in a healthy, online group should show a state of `ONLINE`.

    ```bash
    hastatus -sum
    ```

**Example Scenario (Web Server Service Group):**

Let's say you want to make a web server highly available. It requires a virtual IP address (`192.168.10.100`), a mounted shared file system (`/var/www/html` on `/dev/vx/dsk/web_dg/web_vol`), and the Apache service itself.

```bash
# 1. Create the service group
sudo /opt/VRTS/bin/hagrp -add web_sg

# 2. Add resources
sudo /opt/VRTS/bin/hares -add web_ip IP web_sg
sudo /opt/VRTS/bin/hares -add web_mount Mount web_sg
sudo /opt/VRTS/bin/hares -add web_app Application web_sg

# 3. Configure resource attributes
sudo /opt/VRTS/bin/hares -modify web_ip Address 192.168.10.100
sudo /opt/VRTS/bin/hares -modify web_ip NetworkMask 255.255.255.0
sudo /opt/VRTS/bin/hares -modify web_ip Device eth0

sudo /opt/VRTS/bin/hares -modify web_mount MountPoint /var/www/html
sudo /opt/VRTS/bin/hares -modify web_mount BlockDevice /dev/vx/dsk/web_dg/web_vol
sudo /opt/VRTS/bin/hares -modify web_mount FsType ext4

sudo /opt/VRTS/bin/hares -modify web_app StartProgram "/usr/sbin/httpd -k start"
sudo /opt/VRTS/bin/hares -modify web_app StopProgram "/usr/sbin/httpd -k stop"
sudo /opt/VRTS/bin/hares -modify web_app MonitorProgram "/usr/sbin/httpd -t"
sudo /opt/VRTS/bin/hares -modify web_app MonitorInterval 5

# 4. Define dependencies
sudo /opt/VRTS/bin/hares -link web_ip web_mount
sudo /opt/VRTS/bin/hares -link web_mount web_app

# 6. Enable the service group
sudo /opt/VRTS/bin/hagrp -enable web_sg

# 7. Bring the service group online on node1
sudo /opt/VRTS/bin/hagrp -online web_sg -sys node1

# 8. Verify status
hastatus -sum
```

Remember to adapt these commands and attributes to your specific application and environment. Consult the VCS agent documentation for the correct resource types and attributes for the services you are configuring.