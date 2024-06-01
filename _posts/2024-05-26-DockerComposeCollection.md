---
comments: true
title: Docker Compose Collection
date: 2024-05-21 12:00:00
image:
    path: /assets/img/images_preview/DockerComposePreview.jpeg
math: true
categories: [Virtualization, Docker]
tags: [virtualization, docker, docker-compose]
---

## Transmission-TPE

```yaml
services:
  transmission:
    image: chisbread/transmission:latest        # TR with TPE
    container_name: transmission-tpe
    environment:
      - TZ=Asia/Shanghai
      - PUID=0
      - PGID=0
      # - USER=
      # - PASS=
      # - TRANSMISSION_WEB_HOME=/transmission-web-control
    volumes:
      - /share/Container/transmission-tpe/config:/config
      - /share/Container/transmission-tpe/downloads:/downloads
      - /share:/share
    ports:
      - 6362:9091       # Transmission Web UI port
      - 62002:62002     # Default Transmission port
      - 62002:62002/udp # Default Transmission port (UDP)
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true    # Enable stdin
    tty: true           # Allocate a pseudo-TTY
```

## qBittorrent

```yaml
services:
  qbittorrent:
    image: linuxserver/qbittorrent:14.3.9
    container_name: qbittorrent
    environment:
      - TZ=Asia/Shanghai
      - PUID=0
      - PGID=0
      - WEBUI_PORT=8080
      - TORRENTING_PORT=62000
    volumes:
      - /share/Container/qbittorrent/config:/config
      - /share/Container/qbittorrent/qb-webui:/qb-webui
      - /share:/share
    ports:
      - 6360:8080         # WebUI port
      - 62000:62000       # Torrent port
      - 62000:62000/udp   # Torrent port (UDP)
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

### Fix unauthorized

1. Shutdown the container

2. Add `WebUI\HostHeaderValidation=false` to `qBittorrent.conf`

[Reference](https://www.reddit.com/r/qBittorrent/comments/198f81e/how_to_fix_unauthorized_webui_error_on_truenas/)

### Change password

```markdown
1. Log into WebUI
2. Tools -> Options -> Web UI -> Authentication
```

## IYUUPlus-dev

```yaml
services:
  iyuuplus-dev:
      image: iyuucn/iyuuplus-dev:latest
      container_name: IYUUPlus
      volumes:
        - /share/Container/iyuuplus-dev/iyuu:/iyuu
        - /share/Container/iyuuplus-dev/data:/data
        - /share:/share
      ports:
        - "8780:8780"
      network_mode: bridge
      restart: unless-stopped
      stdin_open: true
      tty: true
```

## Jellyfin

```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    user: 0:0
    volumes:
      - /share/Container/jellyfin/config:/config
      - /share/Container/jellyfin/cache:/cache
      - /share:/media               # Change to your media path
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    devices:
      - /dev/dri:/dev/dri           # Enable GPU Transcoding
    ports:
      - 8096:8096
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

## Jekyll

```yaml
services:
  jekyll:
    image: bretfisher/jekyll-serve
    volumes:
      - /share/Container/jekyll/zhengyuan-public.github.io:/site
      - /share/Container/jekyll/bundle:/usr/local/bundle
    ports:
      - 4000:4000
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

## Vaultwarden

```yaml
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    volumes:
      - /share/Container/vaultwarden/vw-data:/data/
    ports:
      - 8888:80
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

## DuckDNS

```yaml
services: 
  duckdns:
    image: lscr.io/linuxserver/duckdns:latest
    container_name: duckdns-dc
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - SUBDOMAINS={YOUR_SUBDOMAIN_HERE}  # Without the "duckdns.org" suffix
      - TOKEN={YOUR_TOKEN_HERE}
      - UPDATE_IP=ipv4
      - LOG_FILE=false
    volumes:
      - /share/Container/duckdns/config:/config
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

## Nginx Proxy Manager

```yaml
services:
  nginx-proxy-manager:
    image: 'jc21/nginx-proxy-manager:latest'
    ports:
      - 63000:81            # Admin port
      - 63001:80
      - 63002:443
      # Add any other Stream port you want to expose
      # - '21:21' # FTP

    # environment:
      # Uncomment this if you want to change the location of
      # the SQLite DB file within the container
      # DB_SQLITE_FILE: "/data/database.sqlite"
      # Uncomment this if IPv6 is not enabled on your host
      # DISABLE_IPV6: 'true'

    volumes:
      - /share/Container/nginx-proxy-manager/data:/data
      - /share/Container/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

## Navidrome

```yaml
services:
  navidrome:
    image: deluan/navidrome:latest
    user: 0:0 # should be owner of volumes
    environment:
      # Optional: put your config options customization here. Examples:
      ND_SCANSCHEDULE: 1h
      ND_LOGLEVEL: info  
      ND_SESSIONTIMEOUT: 24h
      ND_BASEURL: ''
    ports:
      - 4533:4533
    volumes:
      - /share/Container/navidrome/data:/data
      - /share/Music/__Navidrome:/music:ro
      - /share/Music:/share/Music
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

### *Entware-std

To install additional packages on QNAP NAS, download `Entware-std` from [here](https://www.myqnap.org/product/entware-std/).

```shell
$ opkg update
$ opkg install tree
```

```shell
[/share/Music/__Navidrome] # tree
.
├── Albums
│   └── 100 Best Encores Classics -> /share/Music/Albums/100 Best Encores Classics/
├── Singles
│   └── Dire Straits - Sultans Of Swing.flac
└── syamlink_tar_folder.sh
```

### *Helper Script

```shell
#!/bin/bash

# Use absolute syamlink for Navidrome
# Check if a directory was provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <target_directory>"
  exit 1
fi

TARGET_DIR="$1"

# Ensure the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory does not exist."
  exit 1
fi

# Get the base name of the target directory
BASE_NAME=$(basename "$TARGET_DIR")

# Define the syamlink path
SyamlINK_PATH="/share/Music/__Navidrome/Albums/$BASE_NAME"

# Create the syamlink
ln -s "$TARGET_DIR" "$SyamlINK_PATH"

# Check if the syamlink was created successfully
if [ -L "$SyamlINK_PATH" ]; then
  echo "Syamlink created successfully: $SyamlINK_PATH -> $TARGET_DIR"
else
  echo "Error: Failed to create syamlink."
  exit 1
fi
```

```shell
[/share/Music/__Navidrome] # ./syamlink_tar_folder.sh /share/Music/Albums/demo
Syamlink created successfully: /share/Music/__Navidrome/Albums/demo -> /share/Music/Albums/demo
```

