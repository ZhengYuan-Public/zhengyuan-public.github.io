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

## qBittorrent

```yml
version: '3'
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

## Transmission

### Transmission 2.94

```yml
version: '3'
services:
  transmission:
    image: linuxserver/transmission:2.94-r3-ls53
    container_name: transmission-with-webui
    environment:
      - TZ=Asia/Shanghai
      - PUID=0
      - PGID=0
      # - USER=
      # - PASS=
      - TRANSMISSION_WEB_HOME=/transmission-web-control
    volumes:
      - /share/Container/transmission/config:/config
      - /share/Container/transmission/downloads:/downloads
      - /share:/share
    ports:
      - 6361:9091       # Transmission Web UI port
      - 62001:62001     # Default Transmission port
      - 62001:62001/udp # Default Transmission port (UDP)
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true    # Enable stdin
    tty: true           # Allocate a pseudo-TTY
```

#### Web-UI

```shell
docker exec -it <container_id> bash

# Download from github
wget https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control-cn.sh
# or gitee
wget https://gitee.com/culturist/transmission-web-control/raw/master/release/install-tr-control-gitee.sh

sh install-tr-control-cn.sh
# sh install-tr-control-gitee.sh
```

### Transmission-TPE

```yml
version: '3'
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

## IYUUPlus-dev

```yml
version: '3'
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

```yml
version: '3'
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

> Make sure the docker file is inside your site folder where the `Gemfile` is located..
{: .prompt-tip }

```dockerfile
# Use the official Ruby image as base
FROM ruby:latest

# Set working directory in the container
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile .

# Install dependencies and update Bundler
RUN bundle install && \
    bundle update --bundler && \
    bundle clean --force && \
    rm Gemfile

# Set the default command to be executed when the container starts
CMD ["bash"]
```

```bash
# Build the image
# Make sure CD into the repo folder first
docker build -t jekyll-ruby-env .
```

```yml
version: '3'
services:
  jekyll:
    image: jekyll/jekyll:latest
    working_dir: /srv/jekyll
    command: ["sh", "-c", "bundle install && bundle exec jekyll serve --host 0.0.0.0"]
    volumes:
      - /share/Container/jekyll/zhengyuan-public.github.io:/srv/jekyll
      - /share/Container/bundle:/usr/local/bundle
    ports:
      - 4000:4000
    network_mode: bridge
    restart: unless-stopped
    stdin_open: true      # Enable stdin
    tty: true             # Allocate a pseudo-TTY
```

## Vaultwarden

```yml
version: '3.8'
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

```yml
version: '3.8'
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

```yml
version: '3.8'
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

```yml
version: '3'
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
└── symlink_tar_folder.sh
```

### *Helper Script

```shell
#!/bin/bash

# Use absolute symlink for Navidrome
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

# Define the symlink path
SYMLINK_PATH="/share/Music/__Navidrome/Albums/$BASE_NAME"

# Create the symlink
ln -s "$TARGET_DIR" "$SYMLINK_PATH"

# Check if the symlink was created successfully
if [ -L "$SYMLINK_PATH" ]; then
  echo "Symlink created successfully: $SYMLINK_PATH -> $TARGET_DIR"
else
  echo "Error: Failed to create symlink."
  exit 1
fi
```

```shell
[/share/Music/__Navidrome] # ./symlink_tar_folder.sh /share/Music/Albums/Adele\ -\ 21
Symlink created successfully: /share/Music/__Navidrome/Albums/Adele - 21 -> /share/Music/Albums/Adele - 21
```

