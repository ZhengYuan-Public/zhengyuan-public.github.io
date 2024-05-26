---
comments: true
title: Rename Proxmox Hostname
image:
    path: /assets/img/images_preview/ProxmoxPreview.png
date: 2023-9-14 12:00:00
categories: [Virtualization, Proxmox]
tags: [virtualization, proxmox]
---

## Modify Related Files

```shell
$ nano /etc/hosts
127.0.0.1 localhost.localdomain localhost
# 192.168.1.252 PVE.zhengyuan.local PVE ======> New host name
192.168.1.252 NewPVE.zhengyuan.local NewPVE

# The following lines are desirable for IPv6 capable hosts

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
#--------------------------------------------------------------#

$ nano /etc/hostname
# PVE ======> New host name
NewPVE
#--------------------------------------------------------------#

$ nano /etc/postfix/main.cf
# myhostname=PVE.zhengyuan.local ======> New host name
myhostname=NewPVE.zhengyuan.local

smtpd_banner = $myhostname ESMTP $mail_name (Debian/GNU)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = $myhostname, localhost.$mydomain, localhost
relayhost =
mynetworks = 127.0.0.0/8
inet_interfaces = loopback-only
recipient_delimiter = +

compatibility_level = 2
```

## Restart Services

```shell
# Do this with ssh, the default admin account name is root
$ hostnamectl set-hostname NewPVE
$ systemctl restart pveproxy
$ systemctl restart pvedameon
```

## Move Configuration Files

```shell
$ ls /etc/pve/nodes/
PVE NewPVE

# Backup old config files in case something went wrong
$ cp -r /etc/pve/nodes/PVE ~/config_backup
# Move VM config files
$ cp /etc/pve/nodes/PVE/qemu-server/* /etc/pve/nodes/NewPVE/qemu-server
# Move Linux Container config files
$ cp /etc/pve/nodes/PVE/lxc/* /etc/pve/nodes/NewPVE/lxc
# Remove old files
$ rm -r /etc/pve/nodes/PVE

$ reboot
```

