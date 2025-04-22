# Firewall Port Forward

## Enable ip forwarding in kernel
```shell
echo net.ipv4.ip_forward=1 |sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

```shell
iptables -t nat -I PREROUTING --src 0/0 --dst 192.168.1.5 -p tcp --dport 80 -j REDIRECT --to-ports 8123
iptables -t nat -I OUTPUT --src 0/0 --dst 192.168.1.5 -p tcp --dport 80 -j REDIRECT --to-ports 8123
iptables -t nat -L -n -v
```
