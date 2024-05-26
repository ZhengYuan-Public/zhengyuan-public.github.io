---
comments: true
title: Computer Networking Principles
date: 2024-02-04 12:00:00
image:
    path: /assets/img/images_preview/NetworkPreview.jpg
math: true
categories: [Programming and Development, Networking Principles]
tags: [networking, principle]
---

## IP Address

```shell
root@OpenWrt:~# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP qlen 1000
    link/ether bc:24:11:4c:37:43 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.28/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::be24:11ff:fe4c:3743/64 scope link
       valid_lft forever preferred_lft forever
       
root@OpenWrt:~# cat /etc/config/network

config interface 'loopback'
        option device 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fd7d:4dfe:e28b::/48'

config interface 'wan'
        option device 'eth0'
        option proto 'dhcp'

config interface 'lan'
        option proto 'dhcp'
        option device 'eth1'
        option ipaddr '192.168.1.1'
        option netmask '255.255.255.0'
```

### Some Terminologies

1. Loopback `lo` 
   - IPv4: Typically 127.0.0.1(localhost)**/8**
   - IPv6: Typically ::1(localhost)
2. Abbreviations
   - qlen = queue length
   - inet = IPv4 Address
   - valid_lft = valid Lifetime
   - proto = protocol
3. Gateway = Router

### IP Address Notations

$$
\begin{align}
    &\underbrace{\text{192}}_{Octet}.\text{168.1.1} \\

    &\text{11000000.10101000.00000001.00000001}
\end{align}
$$

### With Subnet Mask

$$
\begin{align}
    &\begin{cases} 
        \text{192.168.1.1} \\
        \text{255.255.255.0}
    \end{cases} \\
    \\
    &\text{192.168.1.1/24} \\
    \\
    &\underbrace{\text{11111111.11111111.11111111.00000000}}_{\text{Classless Inter-Domain Routing (CIDR)}: /24}
\end{align}
$$

