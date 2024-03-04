---
comments: true
title: OpenWrt VM on LXC Container
date: 2024-02-09 12:00:00
image:
    path: /assets/img/images_preview/OpenWrtPreview.png
categories: [Network, OpenWrt, Proxmox, Virtulization]
math: true
tags: [network, openwrt-vm, proxmox, virtulization]
---

## Installation

[Proxmox VE Helper-Scripts](https://tteck.github.io/Proxmox/)

```bash
# Need Proxy in China
$ bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/openwrt.sh)"
```

## Network Configuration

I intend to use OpenWrt as a **virtual router** to handle VPN traffic for my VMs.

### Host Machine Network Configuration

|   Name    |      Type      |    Ports/Slaves     |       CIDR       |   Gateway   |   Comment   |
| :-------: | :------------: | :-----------------: | :--------------: | :---------: | :---------: |
| enp66s0f0 | Network Device |                     |                  |             |             |
| enp66s0f1 | Network Device |                     |                  |             |             |
|   bond0   |   Linux Bond   | enp66s0f0 enp66s0f1 |                  |             |             |
|   vmbr0   |  Linux Bridge  |        bond0        | 192.168.1.252/24 | 192.168.1.1 | Main Bridge |
|   vmbr1   |  Linux Bridge  |                     |                  |             | OpenWrt-LAN |

### OpenWrt VM Network Configuration

```bash
# /etc/config/network

config interface 'loopback'
        option device 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fdfa:8ae4:8fd9::/48'

config interface 'wan'
        option device 'eth0'
        option proto 'dhcp'

config interface 'lan'
        option device 'eth1'
        option proto 'static'
        option ipaddr '192.168.2.1'
        option netmask '255.255.255.0'
```

My modifications

- `eth0` as `WAN`; `eth1` as `LAN`
- `LAN` should have a different subnet static IP, here I used `192.168.2.1`

## Post Installation

### Change OPKG Source

```bash
$ sed -i 's_downloads.openwrt.org_mirrors.tuna.tsinghua.edu.cn/openwrt_' /etc/opkg/distfeeds.conf
```

### Extroot configuration

Reference: [Extroot configuration - OpenWrt](https://openwrt.org/docs/guide-user/additional-software/extroot_configuration)

```bash
# Disk Free
$ df -h
Filesystem                Size      Used Available Use% Mounted on
/dev/root               102.3M     23.6M     76.6M  24% /
tmpfs                   115.7M      1.0M    114.7M   1% /tmp
/dev/sda1                15.7M      5.5M      9.9M  36% /boot
/dev/sda1                15.7M      5.5M      9.9M  36% /boot
tmpfs                   512.0K         0    512.0K   0% /dev
```
#### Add a new disk to the VM (sdb).
```bash
$ ls -l /sys/block
root@OpenWrt:~# ls -l /sys/block
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop0 -> ../devices/virtual/block/loop0
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop1 -> ../devices/virtual/block/loop1
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop2 -> ../devices/virtual/block/loop2
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop3 -> ../devices/virtual/block/loop3
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop4 -> ../devices/virtual/block/loop4
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop5 -> ../devices/virtual/block/loop5
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop6 -> ../devices/virtual/block/loop6
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 loop7 -> ../devices/virtual/block/loop7
lrwxrwxrwx    1 root     root             0 Feb  9 17:45 sda -> ../devices/.../sda
lrwxrwxrwx    1 root     root             0 Feb  9 17:46 sdb -> ../devices/.../sdb
```

#### Partitioning and Formatting

```bash
$ DISK="/dev/sdb"
$ parted -s ${DISK} -- mklabel gpt mkpart extroot 2048s -2048s
$ DEVICE="${DISK}1"
$ mkfs.ext4 -L extroot ${DEVICE}
mke2fs 1.47.0 (9-Feb-2023)
Discarding device blocks: done
Creating filesystem with 261632 4k blocks and 65408 inodes
Filesystem UUID: 09fa106f-02da-4bee-a982-0da3dd8dc0ee
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

$ block info
/dev/sda1: UUID="..." LABEL="kernel" VERSION="1.0" MOUNT="/boot" TYPE="ext4"
/dev/sda2: UUID="..." LABEL="rootfs" VERSION="1.0" MOUNT="/" TYPE="ext4"
/dev/sdb1: UUID="..." LABEL="extroot" VERSION="1.0" TYPE="ext4"
```

#### Configure Extroot

```bash
$ eval $(block info ${DEVICE} | grep -o -e 'UUID="\S*"')
# $ eval $(block info | grep -o -e 'MOUNT="\S*/overlay"')
# This is from the official tutorial, but the partition /overlay is not presented 
# in this installation. You can simply set the variable MOUNT manually.
$ MOUNT="/overlay"
$ uci -q delete fstab.extroot
$ uci set fstab.extroot="mount"
$ uci set fstab.extroot.uuid="${UUID}"
$ uci set fstab.extroot.target="${MOUNT}"
$ uci commit fstab

$ reboot
```

## Softwares

- [OpenClash](https://github.com/vernesong/OpenClash)
  - You might need to uninstall `dnsmasq` with `opkg remove dnsmasq` and let OpenClash to install the full version.