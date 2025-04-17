# tcpdump

## Document reference
- [Redhat Blog for tcpdump](https://www.redhat.com/en/blog/introduction-using-tcpdump-linux-command-line)
- [A tcpdump Tutorial with Examples](https://danielmiessler.com/blog/tcpdump)
- [Tcpdump little book](https://nanxiao.github.io/tcpdump-little-book/)
- [tcpdump for dummies](http://www.alexonlinux.com/tcpdump-for-dummies)
- [Tcpdump advanced filters](https://blog.wains.be/2007/2007-10-01-tcpdump-advanced-filters/)
- [NFS client tcpdump analysis: 3 common failure scenarios](https://access.redhat.com/articles/1342293)

## Install tcpdump
```shell
sudo dnf install tcpdump
```

## List available devices
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -D
1.eth0 [Up, Running, Connected]
2.eth1 [Up, Running, Connected]
3.any (Pseudo-device that captures on all interfaces) [Up, Running]
4.lo [Up, Running, Loopback]
5.bluetooth-monitor (Bluetooth Linux Monitor) [Wireless]
6.usbmon0 (Raw USB traffic, all USB buses) [none]
7.nflog (Linux netfilter log (NFLOG) interface) [none]
8.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]
[vagrant@practice-rocky9 html]$
```

## Capture the packet on particular interface
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:14:51.260678 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 4185410214:4185410274, ack 484659052, win 501, options [nop,nop,TS val 1582261559 ecr 561814969], length 60
17:14:51.260815 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 60:204, ack 1, win 501, options [nop,nop,TS val 1582261559 ecr 561814969], length 144
17:14:51.260899 IP workstation.near2me.biz.44538 > practice-rocky9.near2me.biz.ssh: Flags [.], ack 60, win 501, options [nop,nop,TS val 561815040 ecr 1582261559], length 0
17:14:51.260901 IP workstation.near2me.biz.44538 > practice-rocky9.near2me.biz.ssh: Flags [.], ack 204, win 501, options [nop,nop,TS val 561815040 ecr 1582261559], length 0
17:14:51.260910 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 204:360, ack 1, win 501, options [nop,nop,TS val 1582261559 ecr 561814969], length 156
17:14:51.261054 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 360:464, ack 1, win 501, options [nop,nop,TS val 1582261559 ecr 561815040], length 104
17:14:51.261271 IP workstation.near2me.biz.44538 > practice-rocky9.near2me.biz.ssh: Flags [.], ack 360, win 501, options [nop,nop,TS val 561815041 ecr 1582261559], length 0
```

## Limit the packet capture to 5
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -c 5
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:16:18.927524 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 4185465634:4185465694, ack 484660132, win 501, options [nop,nop,TS val 1582349226 ecr 561902617], length 60
17:16:18.927686 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 60:204, ack 1, win 501, options [nop,nop,TS val 1582349226 ecr 561902617], length 144
17:16:18.927763 IP workstation.near2me.biz.44538 > practice-rocky9.near2me.biz.ssh: Flags [.], ack 60, win 501, options [nop,nop,TS val 561902707 ecr 1582349226], length 0
17:16:18.927765 IP practice-rocky9.near2me.biz.ssh > workstation.near2me.biz.44538: Flags [P.], seq 204:292, ack 1, win 501, options [nop,nop,TS val 1582349226 ecr 561902617], length 88
17:16:18.927842 IP workstation.near2me.biz.44538 > practice-rocky9.near2me.biz.ssh: Flags [.], ack 204, win 501, options [nop,nop,TS val 561902707 ecr 1582349226], length 0
5 packets captured
23 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$ 
```

## disable name and port resolution
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -c 5 -nn
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:16:50.345319 IP 192.168.29.50.22 > 192.168.29.229.44538: Flags [P.], seq 4185468126:4185468186, ack 484660356, win 501, options [nop,nop,TS val 1582380643 ecr 561934061], length 60
17:16:50.345452 IP 192.168.29.50.22 > 192.168.29.229.44538: Flags [P.], seq 60:204, ack 1, win 501, options [nop,nop,TS val 1582380644 ecr 561934061], length 144
17:16:50.345606 IP 192.168.29.229.44538 > 192.168.29.50.22: Flags [.], ack 60, win 501, options [nop,nop,TS val 561934125 ecr 1582380643], length 0
17:16:50.345608 IP 192.168.29.229.44538 > 192.168.29.50.22: Flags [.], ack 204, win 501, options [nop,nop,TS val 561934125 ecr 1582380644], length 0
17:16:50.345625 IP 192.168.29.50.22 > 192.168.29.229.44538: Flags [P.], seq 204:464, ack 1, win 501, options [nop,nop,TS val 1582380644 ecr 561934125], length 260
5 packets captured
15 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$ 
```

## filtering packets based on the protocol
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -c 5 -nn icmp
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:24:26.399861 IP 192.168.29.50 > 192.168.29.229: ICMP echo request, id 12, seq 1, length 64
17:24:26.400002 IP 192.168.29.229 > 192.168.29.50: ICMP echo reply, id 12, seq 1, length 64
17:24:27.439821 IP 192.168.29.50 > 192.168.29.229: ICMP echo request, id 12, seq 2, length 64
17:24:27.440427 IP 192.168.29.229 > 192.168.29.50: ICMP echo reply, id 12, seq 2, length 64
17:24:28.478325 IP 192.168.29.50 > 192.168.29.229: ICMP echo request, id 12, seq 3, length 64
5 packets captured
7 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$ 
```

## filtering the packets to the host
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -c 5 -nn host 192.168.29.229
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:25:40.060906 IP 192.168.29.50.22 > 192.168.29.229.44538: Flags [P.], seq 4185478358:4185478546, ack 484663420, win 501, options [nop,nop,TS val 1582910359 ecr 562463776], length 188
17:25:40.061091 IP 192.168.29.229.44538 > 192.168.29.50.22: Flags [.], ack 0, win 501, options [nop,nop,TS val 562463842 ecr 1582910359], length 0
17:25:40.061092 IP 192.168.29.229.44538 > 192.168.29.50.22: Flags [.], ack 188, win 501, options [nop,nop,TS val 562463842 ecr 1582910359], length 0
17:25:40.165227 IP 192.168.29.50.22 > 192.168.29.229.44538: Flags [P.], seq 188:712, ack 1, win 501, options [nop,nop,TS val 1582910463 ecr 562463842], length 524
17:25:40.165722 IP 192.168.29.229.44538 > 192.168.29.50.22: Flags [.], ack 712, win 501, options [nop,nop,TS val 562463947 ecr 1582910463], length 0
5 packets captured
5 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$ 
```

## filtering the packet to the port
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -c 5 -nn port 80
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:26:40.520462 IP 192.168.29.45.49211 > 192.168.29.50.80: Flags [S], seq 3553736292, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:26:40.520464 IP 192.168.29.45.49211 > 192.168.29.50.80: Flags [S], seq 3553736292, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:26:40.520578 IP 192.168.29.50.80 > 192.168.29.45.49211: Flags [S.], seq 3336574430, ack 3553736293, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
17:26:40.520644 IP 192.168.29.50.80 > 192.168.29.45.49211: Flags [S.], seq 3336574430, ack 3553736293, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
17:26:40.524432 IP 192.168.29.45.49212 > 192.168.29.50.80: Flags [S], seq 3224792628, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
5 packets captured
17 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$ 
```

## filtering packets based on src ip/hostname
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -nn src 192.168.29.45
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:27:40.504186 IP 192.168.29.45.49212 > 192.168.29.50.80: Flags [F.], seq 3224792629, ack 2625588723, win 513, length 0
17:27:40.504188 IP 192.168.29.45.49212 > 192.168.29.50.80: Flags [F.], seq 0, ack 1, win 513, length 0
17:27:40.504189 IP 192.168.29.45.49228 > 192.168.29.50.80: Flags [S], seq 3532310672, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:27:40.504190 IP 192.168.29.45.49228 > 192.168.29.50.80: Flags [S], seq 3532310672, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:27:40.504191 IP 192.168.29.45.49227 > 192.168.29.50.80: Flags [S], seq 3659537706, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:27:40.504192 IP 192.168.29.45.49227 > 192.168.29.50.80: Flags [S], seq 3659537706, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:27:40.509400 IP 192.168.29.45.49228 > 192.168.29.50.80: Flags [.], ack 1049759671, win 256, options [nop,nop,sack 1 {0:1}], length 0
17:27:40.509402 IP 192.168.29.45.49227 > 192.168.29.50.80: Flags [.], ack 1728321893, win 256, length 0
17:27:40.509403 IP 192.168.29.45.49228 > 192.168.29.50.80: Flags [.], ack 1, win 256, options [nop,nop,sack 1 {0:1}], length 0
17:27:40.509404 IP 192.168.29.45.49227 > 192.168.29.50.80: Flags [.], ack 1, win 256, length 0
17:27:40.511080 IP 192.168.29.45.49227 > 192.168.29.50.80: Flags [.], ack 1, win 256, options [nop,nop,sack 1 {0:1}], length 0
17:27:40.511082 IP 192.168.29.45.49227 > 192.168.29.50.80: Flags [.], ack 1, win 256, options [nop,nop,sack 1 {0:1}], length 0
```

## filtering packets based on dest ip/hostname
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -nn dst 192.168.29.45
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:29:42.626051 IP 192.168.29.50.80 > 192.168.29.45.49253: Flags [S.], seq 2421689884, ack 3294311689, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
17:29:42.626117 IP 192.168.29.50.80 > 192.168.29.45.49254: Flags [S.], seq 1090482101, ack 2656948877, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
17:29:42.626146 IP 192.168.29.50.80 > 192.168.29.45.49253: Flags [S.], seq 2421689884, ack 3294311689, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
17:29:42.626171 IP 192.168.29.50.80 > 192.168.29.45.49254: Flags [S.], seq 1090482101, ack 2656948877, win 64240, options [mss 1460,nop,nop,sackOK,nop,wscale 7], length 0
17:29:47.952974 ARP, Request who-has 192.168.29.45 tell 192.168.29.50, length 28
```

## Combine multiple filters using `and` and `or`
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 host 192.168.29.50 and port 80
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:31:41.489519 IP 192.168.29.45.49253 > practice-rocky9.near2me.biz.http: Flags [F.], seq 3294311689, ack 2421689886, win 256, length 0
17:31:41.489522 IP 192.168.29.45.49254 > practice-rocky9.near2me.biz.http: Flags [F.], seq 2656948877, ack 1090482103, win 256, length 0
17:31:41.489523 IP 192.168.29.45.49302 > practice-rocky9.near2me.biz.http: Flags [S], seq 102334820, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:31:41.489524 IP 192.168.29.45.49303 > practice-rocky9.near2me.biz.http: Flags [S], seq 3666611703, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:31:41.489525 IP 192.168.29.45.49253 > practice-rocky9.near2me.biz.http: Flags [F.], seq 0, ack 1, win 256, length 0
17:31:41.489526 IP 192.168.29.45.49254 > practice-rocky9.near2me.biz.http: Flags [F.], seq 0, ack 1, win 256, length 0
17:31:41.489527 IP 192.168.29.45.49302 > practice-rocky9.near2me.biz.http: Flags [S], seq 102334820, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:31:41.489528 IP 192.168.29.45.49303 > practice-rocky9.near2me.biz.http: Flags [S], seq 3666611703, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:31:41.489634 IP practice-rocky9.near2me.biz.http > 192.168.29.45.49253: Flags [R], seq 2421689886, win 0, length 0
```

## Complex expression
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -nn -i eth1 "port 80 and (src 192.168.29.45 or src 192.168.29.229
)"
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:35:59.538202 IP 192.168.29.45.49385 > 192.168.29.50.80: Flags [S], seq 3486748443, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:35:59.538204 IP 192.168.29.45.49385 > 192.168.29.50.80: Flags [S], seq 3486748443, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:35:59.538651 IP 192.168.29.45.49386 > 192.168.29.50.80: Flags [S], seq 376116927, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:35:59.538653 IP 192.168.29.45.49386 > 192.168.29.50.80: Flags [S], seq 376116927, win 64240, options [mss 1460,nop,wscale 8,nop,nop,sackOK], length 0
17:35:59.543982 IP 192.168.29.45.49385 > 192.168.29.50.80: Flags [.], ack 1162986814, win 256, options [nop,nop,sack 1 {0:1}], length 0
17:35:59.543983 IP 192.168.29.45.49386 > 192.168.29.50.80: Flags [.], ack 891449800, win 256, options [nop,nop,sack 1 {0:1}], length 0
17:35:59.543985 IP 192.168.29.45.49386 > 192.168.29.50.80: Flags [P.], seq 0:512, ack 1, win 256, length 512: HTTP: GET / HTTP/1.1
17:35:59.543986 IP 192.168.29.45.49385 > 192.168.29.50.80: Flags [.], ack 1, win 256, options [nop,nop,sack 1 {0:1}], length 0
```

## Capture packet content
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -nn -i eth1 "port 80 and (src 192.168.29.45 or src 192.168.29.229)" -A
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:37:14.990579 IP 192.168.29.229.54934 > 192.168.29.50.80: Flags [S], seq 2739284600, win 64240, options [mss 1460,sackOK,TS val 563158790 ecr 0,nop,wscale 7], length 0
E..<..@.@..9.......2...P.F*x.........j.........
!...........
17:37:14.990875 IP 192.168.29.229.54934 > 192.168.29.50.80: Flags [.], ack 434770562, win 502, options [nop,nop,TS val 563158790 ecr 1583605289], length 0
E..4..@.@..@.......2...P.F*y........b(.....
!...^c.)
17:37:14.990876 IP 192.168.29.229.54934 > 192.168.29.50.80: Flags [P.], seq 0:77, ack 1, win 502, options [nop,nop,TS val 563158790 ecr 1583605289], length 77: HTTP: GET / HTTP/1.1
E.....@.@..........2...P.F*y...............
!...^c.)GET / HTTP/1.1
Host: 192.168.29.50
User-Agent: curl/7.81.0
Accept: */*


17:37:14.991651 IP 192.168.29.229.54934 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 563158791 ecr 1583605290], length 0
E..4..@.@..>.......2...P.F*.........`......
!...^c.*
17:37:14.991837 IP 192.168.29.229.54934 > 192.168.29.50.80: Flags [F.], seq 77, ack 260, win 501, options [nop,nop,TS val 563158791 ecr 1583605290], length 0
E..4..@.@..=.......2...P.F*.........`......
!...^c.*
17:37:14.992131 IP 192.168.29.229.54934 > 192.168.29.50.80: Flags [.], ack 261, win 501, options [nop,nop,TS val 563158791 ecr 1583605290], length 0
E..4..@.@..<.......2...P.F*.........`......
!...^c.*
```

## Capture the packet data to the file
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -nn -i eth1 "port 80 and (src 192.168.29.45 or src 192.168.29.229)" -A -w /tmp/http_packet.pcap
dropped privs to tcpdump
tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C16 packets captured
16 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$
```

## Rotate the pcap capture file based on captured size
```shell
[vagrant@practice-rocky9 tmp]$ sudo tcpdump -i eth1 -nn  -C 1 -w pcap -v
dropped privs to tcpdump
tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
93387 packets captured
93390 packets received by filter
0 packets dropped by kernel
^C[vagrant@practice-rocky9 tmp]$ ls -lrt pcap*
-rw-r--r--. 1 tcpdump tcpdump 1000126 Apr 16 18:08 pcap
-rw-r--r--. 1 tcpdump tcpdump 1000076 Apr 16 18:08 pcap1
-rw-r--r--. 1 tcpdump tcpdump 1000160 Apr 16 18:08 pcap2
-rw-r--r--. 1 tcpdump tcpdump 1000198 Apr 16 18:08 pcap3
-rw-r--r--. 1 tcpdump tcpdump 1000724 Apr 16 18:08 pcap4
-rw-r--r--. 1 tcpdump tcpdump 1000014 Apr 16 18:08 pcap5
-rw-r--r--. 1 tcpdump tcpdump 1000182 Apr 16 18:08 pcap6
-rw-r--r--. 1 tcpdump tcpdump 1000190 Apr 16 18:08 pcap7
-rw-r--r--. 1 tcpdump tcpdump 1000106 Apr 16 18:08 pcap8
-rw-r--r--. 1 tcpdump tcpdump 1000026 Apr 16 18:08 pcap9
-rw-r--r--. 1 tcpdump tcpdump 1000054 Apr 16 18:08 pcap10
-rw-r--r--. 1 tcpdump tcpdump 1000096 Apr 16 18:08 pcap11
-rw-r--r--. 1 tcpdump tcpdump 1000158 Apr 16 18:08 pcap12
-rw-r--r--. 1 tcpdump tcpdump 1000294 Apr 16 18:08 pcap13
-rw-r--r--. 1 tcpdump tcpdump 1000286 Apr 16 18:08 pcap14
-rw-r--r--. 1 tcpdump tcpdump 1001146 Apr 16 18:08 pcap15
-rw-r--r--. 1 tcpdump tcpdump 1000222 Apr 16 18:08 pcap16
-rw-r--r--. 1 tcpdump tcpdump 1000040 Apr 16 18:08 pcap17
-rw-r--r--. 1 tcpdump tcpdump 1000196 Apr 16 18:08 pcap18
-rw-r--r--. 1 tcpdump tcpdump 1000220 Apr 16 18:08 pcap19
-rw-r--r--. 1 tcpdump tcpdump 1000100 Apr 16 18:08 pcap20
-rw-r--r--. 1 tcpdump tcpdump  451930 Apr 16 18:08 pcap21
[vagrant@practice-rocky9 tmp]$ 
```

## Rotate pcap file based on time secs
```shell
[vagrant@practice-rocky9 tmp]$ sudo tcpdump -i eth1 -nn  -G 3 -w pcap_%m%d%Y_%H%M%S -v
dropped privs to tcpdump
tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C53249 packets captured
53252 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 tmp]$ ls -lrt pcap*
-rw-r--r--. 1 tcpdump tcpdump 2131244 Apr 16 18:11 pcap_04162025_181151
-rw-r--r--. 1 tcpdump tcpdump 1875698 Apr 16 18:11 pcap_04162025_181154
-rw-r--r--. 1 tcpdump tcpdump 6047472 Apr 16 18:12 pcap_04162025_181157
-rw-r--r--. 1 tcpdump tcpdump 6309286 Apr 16 18:12 pcap_04162025_181200
-rw-r--r--. 1 tcpdump tcpdump   95908 Apr 16 18:12 pcap_04162025_181203
[vagrant@practice-rocky9 tmp]$ 
```

## Mention the postrotate command to execute on the file
```shell
[vagrant@practice-rocky9 tmp]$ sudo tcpdump -i eth1 -nn  -G 3 -w pcap_%m%d%Y_%H%M%S -v -z gzip 
dropped privs to tcpdump
tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C19 packets captured
23 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 tmp]$ ls -lrt pcap*
-rw-r--r--. 1 tcpdump tcpdump  624 Apr 16 18:14 pcap_04162025_181432.gz
-rw-r--r--. 1 tcpdump tcpdump 1028 Apr 16 18:14 pcap_04162025_181435
[vagrant@practice-rocky9 tmp]$ 
```

## capture and print the packet detail on screen
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -nn -i eth1 "port 80 and (src 192.168.29.45 or src 192.168.29.229)" -A -w /tmp/http_packet2.pcap --print
dropped privs to tcpdump
tcpdump: listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:58:47.268888 IP 192.168.29.229.34258 > 192.168.29.50.80: Flags [S], seq 1881636230, win 64240, options [mss 1460,sackOK,TS val 564451093 ecr 0,nop,wscale 7], length 0
E..<s.@.@..R.......2...Pp'}.........$..........
!...........
17:58:47.269109 IP 192.168.29.229.34258 > 192.168.29.50.80: Flags [.], ack 1412595311, win 502, options [nop,nop,TS val 564451093 ecr 1584897567], length 0
E..4s.@.@..Y.......2...Pp'}.T2~o....|......
!...^w..
17:58:47.269109 IP 192.168.29.229.34258 > 192.168.29.50.80: Flags [P.], seq 0:77, ack 1, win 502, options [nop,nop,TS val 564451093 ecr 1584897567], length 77: HTTP: GET / HTTP/1.1
E...s.@.@..........2...Pp'}.T2~o.....&.....
!...^w..GET / HTTP/1.1
Host: 192.168.29.50
User-Agent: curl/7.81.0
Accept: */*


17:58:47.269611 IP 192.168.29.229.34258 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 564451094 ecr 1584897568], length 0
E..4s.@.@..W.......2...Pp'}.T2.r....{J.....
!...^w. 
17:58:47.269734 IP 192.168.29.229.34258 > 192.168.29.50.80: Flags [F.], seq 77, ack 260, win 501, options [nop,nop,TS val 564451094 ecr 1584897568], length 0
E..4s.@.@..V.......2...Pp'}.T2.r....{I.....
!...^w. 
17:58:47.269871 IP 192.168.29.229.34258 > 192.168.29.50.80: Flags [.], ack 261, win 501, options [nop,nop,TS val 564451094 ecr 1584897568], length 0
E..4s.@.@..U.......2...Pp'}.T2.s....{H.....
!...^w. 
^C6 packets captured
6 packets received by filter
0 packets dropped by kernel
[vagrant@practice-rocky9 html]$ 
```

## Read the packet from pcap file
```shell
[vagrant@practice-rocky9 html]$ tcpdump -r /tmp/http_packet.pcap -nn
reading from file /tmp/http_packet.pcap, link-type EN10MB (Ethernet), snapshot length 262144
17:38:05.169654 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [S], seq 1919420432, win 64240, options [mss 1460,sackOK,TS val 563208970 ecr 0,nop,wscale 7], length 0
17:38:05.170305 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [.], ack 265113555, win 502, options [nop,nop,TS val 563208971 ecr 1583655468], length 0
17:38:05.198354 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [P.], seq 0:77, ack 1, win 502, options [nop,nop,TS val 563208971 ecr 1583655468], length 77: HTTP: GET / HTTP/1.1
17:38:05.200480 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 563209001 ecr 1583655498], length 0
17:38:05.201070 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [F.], seq 77, ack 260, win 501, options [nop,nop,TS val 563209002 ecr 1583655498], length 0
17:38:05.201996 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [.], ack 261, win 501, options [nop,nop,TS val 563209003 ecr 1583655500], length 0

[vagrant@practice-rocky9 html]$ tcpdump -r /tmp/http_packet.pcap -nn -c 5
reading from file /tmp/http_packet.pcap, link-type EN10MB (Ethernet), snapshot length 262144
17:38:05.169654 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [S], seq 1919420432, win 64240, options [mss 1460,sackOK,TS val 563208970 ecr 0,nop,wscale 7], length 0
17:38:05.170305 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [.], ack 265113555, win 502, options [nop,nop,TS val 563208971 ecr 1583655468], length 0
17:38:05.198354 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [P.], seq 0:77, ack 1, win 502, options [nop,nop,TS val 563208971 ecr 1583655468], length 77: HTTP: GET / HTTP/1.1
17:38:05.200480 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 563209001 ecr 1583655498], length 0
17:38:05.201070 IP 192.168.29.229.36946 > 192.168.29.50.80: Flags [F.], seq 77, ack 260, win 501, options [nop,nop,TS val 563209002 ecr 1583655498], length 0
[vagrant@practice-rocky9 html]$ 
```

## Read from multiple pcap file
```shell
cat > pcap_files << EOF
/tmp/http_packet.pcap
/tmp/http_packet1.pcap
/tmp/http_packet2.pcap
EOF
[vagrant@practice-rocky9 tmp]$ sudo tcpdump -nn -V pcap_files  |grep reading
reading from file /tmp/http_packet.pcap, link-type EN10MB (Ethernet), snapshot length 262144
dropped privs to tcpdump
reading from file /tmp/http_packet1.pcap, link-type EN10MB (Ethernet), snapshot length 262144
reading from file /tmp/http_packet2.pcap, link-type EN10MB (Ethernet), snapshot length 262144
[vagrant@practice-rocky9 tmp]$ 
```

## filtering packet capture for entire network
```shell
[vagrant@practice-rocky9 html]$ sudo tcpdump -i eth1 -nn net 192.168.29.0/24 and port not 22
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
17:46:09.232775 IP 192.168.29.1 > 224.0.0.1: igmp query v3
17:46:09.232778 IP 192.168.29.1 > 224.0.0.1: igmp query v3
17:46:09.232779 IP 192.168.29.1 > 224.0.0.1: igmp query v3
17:46:12.916099 IP 192.168.29.229 > 224.0.0.22: igmp v3 report, 1 group record(s)
17:46:14.720375 IP 192.168.29.229.40274 > 192.168.29.50.80: Flags [S], seq 956841644, win 64240, options [mss 1460,sackOK,TS val 563698534 ecr 0,nop,wscale 7], length 0
17:46:14.720424 IP 192.168.29.50.80 > 192.168.29.229.40274: Flags [S.], seq 2199179700, ack 956841645, win 65160, options [mss 1460,sackOK,TS val 1584145019 ecr 563698534,nop,wscale 7], length 0
17:46:14.720655 IP 192.168.29.229.40274 > 192.168.29.50.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 563698534 ecr 1584145019], length 0
17:46:14.720656 IP 192.168.29.229.40274 > 192.168.29.50.80: Flags [P.], seq 1:78, ack 1, win 502, options [nop,nop,TS val 563698534 ecr 1584145019], length 77: HTTP: GET / HTTP/1.1
17:46:14.720678 IP 192.168.29.50.80 > 192.168.29.229.40274: Flags [.], ack 78, win 509, options [nop,nop,TS val 1584145019 ecr 563698534], length 0
17:46:14.721301 IP 192.168.29.50.80 > 192.168.29.229.40274: Flags [P.], seq 1:260, ack 78, win 509, options [nop,nop,TS val 1584145019 ecr 563698534], length 259: HTTP: HTTP/1.1 200 OK
17:46:14.721504 IP 192.168.29.229.40274 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 563698535 ecr 1584145019], length 0
17:46:14.721746 IP 192.168.29.229.40274 > 192.168.29.50.80: Flags [F.], seq 78, ack 260, win 501, options [nop,nop,TS val 563698535 ecr 1584145019], length 0
17:46:14.721851 IP 192.168.29.50.80 > 192.168.29.229.40274: Flags [F.], seq 260, ack 79, win 509, options [nop,nop,TS val 1584145020 ecr 563698535], length 0
17:46:14.722059 IP 192.168.29.229.40274 > 192.168.29.50.80: Flags [.], ack 261, win 501, options [nop,nop,TS val 563698535 ecr 1584145020], length 0
17:46:23.510435 ARP, Request who-has 192.168.29.190 tell 192.168.29.45, length 46
17:46:23.510453 ARP, Request who-has 192.168.29.236 tell 192.168.29.45, length 46
17:46:25.118334 ARP, Request who-has 192.168.29.229 tell 192.168.29.1, length 46
17:46:29.303328 IP 192.168.29.1 > 224.0.0.1: igmp query v3
17:46:29.303330 IP 192.168.29.1 > 224.0.0.1: igmp query v3
17:46:29.303331 IP 192.168.29.1 > 224.0.0.1: igmp query v3
17:46:31.859441 IP 192.168.29.229 > 224.0.0.22: igmp v3 report, 1 group record(s)
17:46:34.012367 ARP, Request who-has 192.168.29.229 (20:16:b9:31:40:98) tell 192.168.29.45, length 46
17:46:38.486118 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [S], seq 754793807, win 64240, options [mss 1460,sackOK,TS val 2440996815 ecr 0,nop,wscale 7], length 0
17:46:38.486120 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [S], seq 754793807, win 64240, options [mss 1460,sackOK,TS val 2440996815 ecr 0,nop,wscale 7], length 0
17:46:38.486238 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [S.], seq 4117586325, ack 754793808, win 65160, options [mss 1460,sackOK,TS val 358233890 ecr 2440996815,nop,wscale 7], length 0
17:46:38.486310 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [S.], seq 4117586325, ack 754793808, win 65160, options [mss 1460,sackOK,TS val 358233890 ecr 2440996815,nop,wscale 7], length 0
17:46:38.489561 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 2440996819 ecr 358233890], length 0
17:46:38.489563 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 2440996819 ecr 358233890], length 0
17:46:38.490460 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 2440996819 ecr 358233890], length 0
17:46:38.490462 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [P.], seq 1:78, ack 1, win 502, options [nop,nop,TS val 2440996819 ecr 358233890], length 77: HTTP: GET / HTTP/1.1
17:46:38.490463 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 1, win 502, options [nop,nop,TS val 2440996819 ecr 358233890], length 0
17:46:38.490464 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [P.], seq 1:78, ack 1, win 502, options [nop,nop,TS val 2440996819 ecr 358233890], length 77: HTTP: GET / HTTP/1.1
17:46:38.490547 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [.], ack 78, win 509, options [nop,nop,TS val 358233895 ecr 2440996819], length 0
17:46:38.490689 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [.], ack 78, win 509, options [nop,nop,TS val 358233895 ecr 2440996819], length 0
17:46:38.490732 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [.], ack 78, win 509, options [nop,nop,TS val 358233895 ecr 2440996819,nop,nop,sack 1 {1:78}], length 0
17:46:38.491568 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [P.], seq 1:260, ack 78, win 509, options [nop,nop,TS val 358233896 ecr 2440996819], length 259: HTTP: HTTP/1.1 200 OK
17:46:38.496858 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 2440996825 ecr 358233896], length 0
17:46:38.496860 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [F.], seq 78, ack 260, win 501, options [nop,nop,TS val 2440996825 ecr 358233896], length 0
17:46:38.496861 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 260, win 501, options [nop,nop,TS val 2440996825 ecr 358233896], length 0
17:46:38.496862 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [F.], seq 78, ack 260, win 501, options [nop,nop,TS val 2440996825 ecr 358233896], length 0
17:46:38.496939 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [.], ack 79, win 509, options [nop,nop,TS val 358233901 ecr 2440996825,nop,nop,sack 1 {78:79}], length 0
17:46:38.497251 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [F.], seq 260, ack 79, win 509, options [nop,nop,TS val 358233901 ecr 2440996825], length 0
17:46:38.499552 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 261, win 501, options [nop,nop,TS val 2440996829 ecr 358233901], length 0
17:46:38.499554 IP 192.168.29.45.51350 > 192.168.29.50.80: Flags [.], ack 261, win 501, options [nop,nop,TS val 2440996829 ecr 358233901], length 0
17:46:38.499612 IP 192.168.29.50.80 > 192.168.29.45.51350: Flags [R], seq 4117586586, win 0, length 0
17:46:43.023303 ARP, Request who-has 192.168.29.50 (20:16:b9:31:40:98) tell 192.168.29.45, length 46
17:46:43.023376 ARP, Reply 192.168.29.50 is-at 08:00:27:7f:92:64, length 28
17:46:43.759413 ARP, Request who-has 192.168.29.45 tell 192.168.29.50, length 28
17:46:43.761327 ARP, Reply 192.168.29.45 is-at d4:54:8b:5f:6c:1b, length 46
17:46:44.661851 ARP, Request who-has 192.168.29.105 tell 192.168.29.45, length 46
17:46:48.243273 ARP, Request who-has 192.168.29.50 tell 192.168.29.229, length 46
17:46:48.243342 ARP, Reply 192.168.29.50 is-at 08:00:27:7f:92:64, length 28
17:46:49.951358 ARP, Reply 192.168.29.1 is-at 04:ab:08:b7:70:61, length 46
```
