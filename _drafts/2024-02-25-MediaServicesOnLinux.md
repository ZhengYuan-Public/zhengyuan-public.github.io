---
comments: true
title: Media Services On Linux
date: 2024-02-25 12:00:00
image:
    path: /assets/img/images_preview/MultimediaPreview.jpg
categories: [Network, OpenWrt, Proxmox]
math: true
tags: [network, openwrt-vm, proxmox]
---

## List of Media Services

- Plex
- Jellyfin
- Navidrome
- Calibre

## Jellyfin



### Navidrome

#### Service File

```toml
[Unit]
Description=Navidrome Music Server and Streamer compatible with Subsonic/Airsonic
After=remote-fs.target network.target
AssertPathExists=/home/foo/Documents/navidrome

[Install]
WantedBy=multi-user.target

[Service]
User=foo
Type=simple
ExecStart=/home/foo/Documents/navidrome/navidrome --configfile \ "/home/foo/Documents/navidrome/navidrome.toml"
WorkingDirectory=/home/foo/Documents/navidrome
TimeoutStopSec=20
KillMode=process
Restart=on-failure

# See https://www.freedesktop.org/software/systemd/man/systemd.exec.html
DevicePolicy=closed
NoNewPrivileges=yes
PrivateTmp=yes
PrivateUsers=yes
ProtectControlGroups=yes
ProtectKernelModules=yes
ProtectKernelTunables=yes
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
RestrictNamespaces=yes
RestrictRealtime=yes
SystemCallFilter=~@clock @debug @module @mount @obsolete @reboot @setuid @swap
ReadWritePaths=/home/foo/Documents/navidrome

ProtectSystem=full
```

#### Start Service

```bash
# Start Service
sudo systemctl daemon-reload
sudo systemctl start navidrome.service
sudo systemctl status navidrome.service

# Start Service on Boot
sudo systemctl enable navidrome.service
```

