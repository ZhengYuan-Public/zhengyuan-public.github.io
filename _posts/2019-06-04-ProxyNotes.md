---
comments: true
title: Use Proxy in Terminal
date: 2019-06-03 12:00:00
categories: [network, proxy, terminal]
tags: [network, proxy, terminal]
---

## Download VPN Software

- [Clash for Windows - Release](https://github.com/Fndroid/clash_for_windows_pkg/releases)
- Your VPN provider, [QQWLJS](https://qqwljs.buzz/#/register?code=p9tKWlt9), or [TLY]( https://u2263835.tly.sh/2263835)

## Proxy the Terminal

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

### Windows CMD

```cmd
# Set the proxy environment variables
set http_proxy=http://127.0.0.1:1080
set https_proxy=http://127.0.0.1:1080

# Unset the proxy environment variables
set http_proxy=
set https_proxy=
```
