---
comments: true
title: Proxy Notes
date: 2019-06-05 12:00:00
image:
    path: /assets/img/images_preview/ProxyPreview.png
categories: [Programming and Development, Proxy]
tags: [network, proxy, terminal]
---

## VPN Software

- [Clash for Windows - Release](https://github.com/Fndroid/clash_for_windows_pkg/releases)

## Terminal

### macOS and Linux

The environment variables for proxy are `http_proxy`, `https_proxy`, and `all_proxy`. 

- The port I used (also the default for *Clash for Windows*) is `7890`
- You can replace `127.0.0.1` with `localhost`

```bash
# Set the proxy environment variables
export http_proxy=http://127.0.0.1:7890
export https_proxy=https://127.0.0.1:7890
export all_proxy=socks5://127.0.0.1:7890

# Unset the proxy environment variables
unset http_proxy https_proxy all_proxy
```

You can set the *Proxy Mode* of Clash for Windows to `Global` or enable the `TUN` mode (see doc [here](https://docs.cfw.lbyczf.com/contents/tun.html)).

```bash
# Test Proxy Connection
$ curl cip.cc

# If successful, you should see the IP address of your VPN server
IP	: xxx.xxx.xxx.xxx
地址	: 日本  东京都  品川区
运营商	: linode.com
数据二	: 日本 | 东京都品川区Linode数据中心
数据三	: 日本东京都东京
URL	: http://www.cip.cc/xxx.xxx.xxx.xxx
```

For convenience, you can add two functions in the shell config file

```bash
$ echo $SHELL
/bin/zsh

# Add the following lines to the end of the file ~/.zshrc
function proxy_on() {
    export https_proxy=http://127.0.0.1:7890
    export http_proxy=http://127.0.0.1:7890
    export all_proxy=socks5://127.0.0.1:7890
    echo -e "Proxy is On"
    curl cip.cc
}

function proxy_off(){
    unset http_proxy https_proxy all_proxy
    echo -e "Proxy is Off"
    curl cip.cc
}
```

### Windows

```shell
# Set the proxy environment variables
set http_proxy=http://127.0.0.1:7890
set https_proxy=http://127.0.0.1:7890

# Unset the proxy environment variables
set http_proxy=
set https_proxy=
```

## Use VPN Shared by LAN

In *Clash for Windows*, enable **Allow LAN** from the setting and look at the information in the Network Interfaces.

```yaml
vEthernet (Default Switch)
Address:    172.31.80.1
Netmask:    255.255.240.0 (20)
MAC:        00:15:5d:48:8d:cf

WLAN
Address:    192.168.1.49
Netmask:    255.255.255.0 (24)
MAC:        a4:6b:b6:40:15:46

Loopback Pseudo-Interface 1
Address:    127.0.0.1
Netmask:    255.0.0.0 (8)
MAC:        0:00:00:00:00:00
```

In the `WLAN` section, the address is the IP address of your computer. The VPN shared by LAN is then `http://192.168.1.49:7890`. The use it to replace the `http://127.0.0.1` in previous sections.
