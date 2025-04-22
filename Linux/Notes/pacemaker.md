# pacemaker

## Links and reference
 * [Red Hat Document](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_high_availability_clusters/index)

## Enable HighAvailability repo
```shell
dnf repolist --all |grep -i highavailability
dnf config-manager --enable highavailability
```

## Packages need to install
```shell
dnf install  pcs fence-agents-all pcp-zeroconf -y
```

## Enable firewall rule to enable comminucation on HA port
```shell
firewall-cmd --permanent --add-service=HighAvailability
firewall-cmd --reload
```

## Bounce and enabled the service
```shell
systemctl enable pcsd
systemctl start pcsd
```

## Authorize the hosts
`pcs host auth` will prompt for the username password to connect to the nodes.
```shell
pcs host auth pcsnode1 pcsnode2
```

## Setup the cluster 
```shell
pcs cluster setup test_cluster --start pcsnode1 pcsnode2
```

## To enable the cluster to start boot
```shell
pcs cluster enable --all
```

## Get cluster status
```shell
pcs cluster status
```

## To get detailed status including daemon status
```shell
pcs status
```

## Disable fencing if we dont use
```shell
pcs property set stonith-enabled=false
```

## Install the apache on nodes
```shell
dnf install -y httpd
```

## Create and mount shared volume on /var/www
 * scan and detect the new disk
 * Create partition and create LVM pv on the disk
 * Create VG and LV on the disk. The VG should be `--setautoactivation n` to activate the vg on node
 * mount the file system on /var/www
 * create sub directory html,cgi-bin and error
 * Restore SELinux context on the new mount

## List available resource for apache
```shell
pcs resource describe apache
```

## Create the file system resource for apache
```shell
# List available config for the resource Filesystem
pcs resource describe Filesystem
pcs resource create httpd_fs Filesystem device="/dev/vg_data/lv_data" directory="/var/www" fstype="xfs" --group apache
```

## Create the cluster VIP for apache
```shell
# List available resource for cluster ip
pcs resource descrive IPaddr2
pcs resource create httpd_vip IPaddr2 ip="192.168.29.80" cidr_netmask=24 --group apache
```

## Create server-status endpoint for apache server
```shell
cat <<-END > /etc/httpd/conf.d/status.conf
<Location /server-status>
    SetHandler server-status
    Order deny,allow
    Deny from all
    Allow from 127.0.0.1
    Allow from ::1
</Location>
END
```

## Create apache resource
```shell
# List available resource for apace
pcs resource describe apache
pcs resource create httpd_conf apache configfile="/etc/httpd/conf/httpd.conf" status-url="http://127.0.0.1/server-status" --group apache
```

## Get the status of the cluster
```shell
[root@pcsnode1-rocky9 ~]# pcs status
Cluster name: test_cluster
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: pcsnode1 (version 2.1.8-3.el9-3980678f0) - partition with quorum
  * Last updated: Mon Apr 21 18:19:38 2025 on pcsnode1
  * Last change:  Mon Apr 21 18:15:15 2025 by hacluster via hacluster on pcsnode2
  * 2 nodes configured
  * 3 resource instances configured

Node List:
  * Online: [ pcsnode1 pcsnode2 ]

Full List of Resources:
  * Resource Group: apache:
    * httpd_fs  (ocf:heartbeat:Filesystem):      Started pcsnode2
    * httpd_vip (ocf:heartbeat:IPaddr2):         Started pcsnode2
    * httpd_conf        (ocf:heartbeat:apache):  Started pcsnode2

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@pcsnode1-rocky9 ~]# 
```

## Check the website now
```shell
[root@pcsnode1-rocky9 ~]# curl 192.168.29.80
<html>
<body>Hello, Welcome!. This Page Is Served By Red Hat Hight Availability Cluster</body>
</html>
[root@pcsnode1-rocky9 ~]#
```
## Do the failover test by putting the node which running resource in standby
```shell
[root@pcsnode1-rocky9 ~]# pcs node standby pcsnode2
[root@pcsnode1-rocky9 ~]# pcs status
Cluster name: test_cluster
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: pcsnode1 (version 2.1.8-3.el9-3980678f0) - partition with quorum
  * Last updated: Mon Apr 21 18:20:55 2025 on pcsnode1
  * Last change:  Mon Apr 21 18:20:47 2025 by root via root on pcsnode1
  * 2 nodes configured
  * 3 resource instances configured

Node List:
  * Node pcsnode2: standby
  * Online: [ pcsnode1 ]

Full List of Resources:
  * Resource Group: apache:
    * httpd_fs  (ocf:heartbeat:Filesystem):      Started pcsnode1
    * httpd_vip (ocf:heartbeat:IPaddr2):         Started pcsnode1
    * httpd_conf        (ocf:heartbeat:apache):  Started pcsnode1

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@pcsnode1-rocky9 ~]#
```

## Bring back the node 
```shell
[root@pcsnode1-rocky9 ~]# pcs node unstandby pcsnode2
[root@pcsnode1-rocky9 ~]# pcs status
Cluster name: test_cluster
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: pcsnode1 (version 2.1.8-3.el9-3980678f0) - partition with quorum
  * Last updated: Mon Apr 21 18:21:42 2025 on pcsnode1
  * Last change:  Mon Apr 21 18:21:36 2025 by root via root on pcsnode1
  * 2 nodes configured
  * 3 resource instances configured

Node List:
  * Online: [ pcsnode1 pcsnode2 ]

Full List of Resources:
  * Resource Group: apache:
    * httpd_fs  (ocf:heartbeat:Filesystem):      Started pcsnode1
    * httpd_vip (ocf:heartbeat:IPaddr2):         Started pcsnode1
    * httpd_conf        (ocf:heartbeat:apache):  Started pcsnode1

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@pcsnode1-rocky9 ~]#
```

## Get current cluster configuration
```shell
pcs cluster cib original.xml
```

## Create new configuration on the configuration file instead of on cluster
```shell
cp origial.xml updated.xml
pcs -f original.xml resource create httpd_vip2 IPaddr ip="192.168.29.90" cidr_mask=24 --group apache
```
## Push the new configuration to the cluster
```shell
[root@pcsnode1-rocky9 ~]# pcs cluster cib-push updated.xml
CIB updated
[root@pcsnode1-rocky9 ~]# pcs status
Cluster name: test_cluster
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: pcsnode1 (version 2.1.8-3.el9-3980678f0) - partition with quorum
  * Last updated: Mon Apr 21 18:34:09 2025 on pcsnode1
  * Last change:  Mon Apr 21 18:34:05 2025 by root via root on pcsnode1
  * 2 nodes configured
  * 4 resource instances configured

Node List:
  * Online: [ pcsnode1 pcsnode2 ]

Full List of Resources:
  * Resource Group: apache:
    * httpd_fs  (ocf:heartbeat:Filesystem):      Started pcsnode1
    * httpd_vip (ocf:heartbeat:IPaddr2):         Started pcsnode1
    * httpd_conf        (ocf:heartbeat:apache):  Started pcsnode1
    * httpd_vip2        (ocf:heartbeat:IPaddr2):         Started pcsnode1

Daemon Status:
  corosync: active/disabled
  pacemaker: active/disabled
  pcsd: active/enabled
[root@pcsnode1-rocky9 ~]#
```

## Get status of the nodes, cluster, resources and pcsd
```shell
[root@pcsnode1-rocky9 ~]# pcs status nodes
Pacemaker Nodes:
 Online: pcsnode1 pcsnode2
 Standby:
 Standby with resource(s) running:
 Maintenance:
 Offline:
Pacemaker Remote Nodes:
 Online:
 Standby:
 Standby with resource(s) running:
 Maintenance:
 Offline:
[root@pcsnode1-rocky9 ~]# pcs status resources
  * Resource Group: apache:
    * httpd_fs  (ocf:heartbeat:Filesystem):      Started pcsnode1
    * httpd_vip (ocf:heartbeat:IPaddr2):         Started pcsnode1
    * httpd_conf        (ocf:heartbeat:apache):  Started pcsnode1
    * httpd_vip2        (ocf:heartbeat:IPaddr2):         Started pcsnode1
[root@pcsnode1-rocky9 ~]# pcs status cluster
Cluster Status:
 Cluster Summary:
   * Stack: corosync (Pacemaker is running)
   * Current DC: pcsnode1 (version 2.1.8-3.el9-3980678f0) - partition with quorum
   * Last updated: Mon Apr 21 18:36:16 2025 on pcsnode1
   * Last change:  Mon Apr 21 18:34:05 2025 by root via root on pcsnode1
   * 2 nodes configured
   * 4 resource instances configured
 Node List:
   * Online: [ pcsnode1 pcsnode2 ]

PCSD Status:
  pcsnode1: Online
  pcsnode2: Online
[root@pcsnode1-rocky9 ~]# ^C
[root@pcsnode1-rocky9 ~]# pcs status pcsd
  pcsnode1: Online
  pcsnode2: Online
[root@pcsnode1-rocky9 ~]#
```

## Backing up the cluster config
```shell
pcs config backup cluster_config
```

## Restore the cluster config from backup
```shell
pcs config restore --local cluster_config
```
