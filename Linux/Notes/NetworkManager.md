# NetworkManager

## Get current ip, route and dns details
```shell
[kannan@practice-rocky8 ~]$ nmcli
enp0s3: connected to Wired connection 1
        "Intel 82540EM"
        ethernet (e1000), 08:00:27:6E:B2:9D, hw, mtu 1500
        ip4 default, ip6 default
        inet4 192.168.29.73/24
        route4 192.168.29.0/24 metric 100
        route4 default via 192.168.29.1 metric 100
        inet6 2405:201:e050:485d:abdf:e2af:f2f7:8e5d/64
        inet6 fe80::5935:d5be:781e:d31b/64
        route6 fe80::/64 metric 1024
        route6 2405:201:e050:485d::/64 metric 100
        route6 default via fe80::6ab:8ff:feb7:7061 metric 100

enp0s8: disconnected
        "Intel 82540EM"
        1 connection available
        ethernet (e1000), 08:00:27:0F:21:3D, hw, mtu 1500

lo: unmanaged
        "lo"
        loopback (unknown), 00:00:00:00:00:00, sw, mtu 65536

DNS configuration:
        servers: 192.168.29.1
        interface: enp0s3

        servers: 2405:201:e050:485d::c0a8:1d01
        interface: enp0s3

Use "nmcli device show" to get complete information about known devices and
"nmcli connection show" to get an overview on active connection profiles.

Consult nmcli(1) and nmcli-examples(7) manual pages for complete usage details.
[kannan@practice-rocky8 ~]$
```

## Get available devices
```shell
[kannan@practice-rocky8 ~]$ nmcli device
DEVICE  TYPE      STATE      CONNECTION 
enp0s3  ethernet  connected  enp0s3     
enp0s8  ethernet  connected  enp0s8     
lo      loopback  unmanaged  --         
[kannan@practice-rocky8 ~]$
```

## To view the connection
```shell
[kannan@practice-rocky8 ~]$ nmcli con show
NAME    UUID                                  TYPE      DEVICE 
enp0s3  a57c1197-a517-39ed-865b-3c436adfba65  ethernet  enp0s3 
enp0s8  6a14e5e1-e3c9-365e-86bd-db0c83c053b5  ethernet  enp0s8 
[kannan@practice-rocky8 ~]$
```

## Set the ipv4 address to the interface
```shell
[kannan@practice-rocky8 ~]$ sudo nmcli con modify enp0s8 ipv4.addr 192.168.56.10/24 gw4 192.168.56.1 ipv4.dns 192.168.56.1
[kannan@practice-rocky8 ~]$ sudo nmcli con down enp0s8
Connection 'enp0s8' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/2)
[kannan@practice-rocky8 ~]$ sudo nmcli con up enp0s8
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/3)
[kannan@practice-rocky8 ~]$ nmcli
enp0s3: connected to enp0s3
        "Intel 82540EM"
        ethernet (e1000), 08:00:27:6E:B2:9D, hw, mtu 1500
        ip4 default
        inet4 192.168.29.73/24
        route4 192.168.29.0/24 metric 100
        route4 default via 192.168.29.1 metric 100
        inet6 fe80::5935:d5be:781e:d31b/64
        route6 fe80::/64 metric 1024

enp0s8: connected to enp0s8
        "Intel 82540EM"
        ethernet (e1000), 08:00:27:0F:21:3D, hw, mtu 1500
        inet4 192.168.56.10/24
        route4 192.168.56.0/24 metric 101
        route4 default via 192.168.56.1 metric 101
        inet6 fe80::b311:dcfb:51a2:760/64
        route6 fe80::/64 metric 1024

lo: unmanaged
        "lo"
        loopback (unknown), 00:00:00:00:00:00, sw, mtu 65536

DNS configuration:
        servers: 192.168.29.1
        interface: enp0s3

        servers: 192.168.56.1
        interface: enp0s8

Use "nmcli device show" to get complete information about known devices and
"nmcli connection show" to get an overview on active connection profiles.

Consult nmcli(1) and nmcli-examples(7) manual pages for complete usage details.
[kannan@practice-rocky8 ~]$ 
```
