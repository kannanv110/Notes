# iscsi target/initiator

## Links and references
 * [Red Hat Document](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html/managing_storage_devices/configuring-an-iscsi-target_managing-storage-devices#creating-a-fileio-storage-object_configuring-an-iscsi-target)

## Install iscsi target and enable/start the service
```shell
sudo dnf install -y targetcli
sudo systemctl start target
sudo systemctl enable target
```

## Create 1Gb iscsi lun from the file
```shell
sudo targetcli
# Create file storage
/> /backstores/fileio create name=my_iscsi_storage file_or_dev=/dev/sdb size=1G
Created fileio my_iscsi_storage with size 1073741824
# Create target
/> /iscsi create iqn.2025-04.com.example:target1
Created target iqn.2025-04.com.example:target1.
Created TPG 1.
Global pref auto_add_default_portal=true
Created default portal listening on all IPs (0.0.0.0), port 3260.
# Create portal to listen on incoming connections
/> /iscsi/iqn.2025-04.com.example:target1/tpg1/portals create 0.0.0.0 3260
Using default IP port 3260
Binding to INADDR_ANY (0.0.0.0)
This NetworkPortal already exists in configFS
# Create an Access Control List (ACL) for the initiator that will connect to the target:
/> /iscsi/iqn.2025-04.com.example:target1/tpg1/acls create iqn.2025-04.com.initiator:pcsnode1
Created Node ACL for iqn.2025-04.com.initiator:pcsnode1
/> /iscsi/iqn.2025-04.com.example:target1/tpg1/acls create iqn.2025-04.com.initiator:pcsnode2
Created Node ACL for iqn.2025-04.com.initiator:pcsnode2
# Map the backstore to the iscsi target
/> /iscsi/iqn.2025-04.com.example:target1/tpg1/luns/ create /backstores/fileio/my_iscsi_storage
Created LUN 0.
Created LUN 0->0 mapping in node ACL iqn.2025-04.com.initiator:pcsnode2
Created LUN 0->0 mapping in node ACL iqn.2025-04.com.initiator:pcsnode1
# Save the cofig and exit
/> saveconfig
Last 10 configs saved in /etc/target/backup/.
Configuration saved to /etc/target/saveconfig.json
/> exit
Global pref auto_save_on_exit=true
Last 10 configs saved in /etc/target/backup/.
Configuration saved to /etc/target/saveconfig.json
```

## Install iscsi initiator on the client
```shell
sudo dnf install -y iscsi-initiator-utils
```
## Update initiator name
```shell
[vagrant@pcsnode1-rocky9 ~]$ echo InitiatorName=iqn.2025-04.com.initiator:pcsnode1 |sudo tee /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.2025-04.com.initiator:pcsnode1
[vagrant@pcsnode1-rocky9 ~]$
[vagrant@pcsnode2-rocky9 ~]$ echo InitiatorName=iqn.2025-04.com.initiator:pcsnode2 |sudo tee /etc/iscsi/initiatorname.iscsi
InitiatorName=iqn.2025-04.com.initiator:pcsnode2
[vagrant@pcsnode2-rocky9 ~]$ 
```

## Discover the iscsi target
Here `iscsi-target` is the hostname of the iscsi target machine
```shell
[vagrant@pcsnode1-rocky9 ~]$ sudo iscsiadm -m discovery -t sendtargets -p iscsi-target 
192.168.29.50:3260,1 iqn.2025-04.com.example:target1
[vagrant@pcsnode1-rocky9 ~]$ 
```

## Login to the target
Here `iscsi-target` is the hostname of the iscsi target machine
```shell
[vagrant@pcsnode1-rocky9 ~]$ sudo iscsiadm -m node --targetname iqn.2025-04.com.example:target1 --portal iscsi-target:3260 --login
Logging in to [iface: default, target: iqn.2025-04.com.example:target1, portal: 192.168.29.50,3260]
Login to [iface: default, target: iqn.2025-04.com.example:target1, portal: 192.168.29.50,3260] successful.
[vagrant@pcsnode1-rocky9 ~]$
```

## Enable automatic login at boot
```shell
[vagrant@pcsnode1-rocky9 ~]$ sudo iscsiadm -m node --targetname iqn.2025-04.com.example:target1 --portal iscsi-target:3260 --op update --name node.startup --value automatic
[vagrant@pcsnode1-rocky9 ~]$
```

## List the lun now
```shell
[vagrant@pcsnode1-rocky9 ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   10G  0 disk 
├─sda1   8:1    0  100M  0 part /boot/efi
├─sda2   8:2    0 1000M  0 part /boot
├─sda3   8:3    0    4M  0 part 
├─sda4   8:4    0    1M  0 part 
└─sda5   8:5    0  7.8G  0 part /
sdb      8:16   0    1G  0 disk 
[vagrant@pcsnode1-rocky9 ~]$
```





