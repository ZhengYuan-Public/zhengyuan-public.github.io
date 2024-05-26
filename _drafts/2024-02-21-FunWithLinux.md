---
comments: true
title: Fun With Linux
date: 2024-02-21 12:00:00
image:
    path: /assets/img/images_preview/LinuxDistrosPreview.jpg
categories: [Operating System, Linux]
math: true
tags: [operating-system, os, linux]
---

## List of Notes

In order to migrate from Windows to Linux, this post is intended to keep notes on a list of equivalent actions on Linux which is often configured on Windows.

- Installing Software
- Configuring Network
- Tracking Logs
- Listing Startup Apps

## List Start on Boot Apps/Services

```bash
# In Debian and Ubuntu Distro
$ ls /etc/init.d
acpid             cups-browsed       nmbd                         speech-dispatcher
alsa-utils        dbus               nvidia-gridd                 spice-vdagent
anacron           gdm3               openvpn                      ssh
apparmor          grub-common        plymouth                     udev
apport            hwclock.sh         plymouth-log                 ufw
atd               irqbalance         procps                       unattended-upgrades
avahi-daemon      jellyfin           pulseaudio-enable-autospawn  uuidd
bluetooth         kerneloops         rsync                        whoopsie
console-setup.sh  keyboard-setup.sh  samba-ad-dc                  x11-common
cron              kmod               saned
cups              lightdm            smbd

# However, some
$ systemctl list-unit-files | grep enabled
```

> In Linux, the suffix ".d" stands for directory. Configuration directories, or ".d" directories, are used to configure programs by placing small files in them instead of editing a single file. Here are some examples:
>
> - `/etc/init.d`
> - `/etc/grub.d`

## Track Logs - `journalctl`

[How To Use Journalctl to View and Manipulate Systemd Logs](https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs)

```bash
$ journalctl -b -u -f jellyfin
# -b: only logs since the most recent reboot
# -u: filter by unit
# -f: actively follow the logs as they are being written
```

## Commands and Tools

```bash
$ ps -aux
$ htop
```





