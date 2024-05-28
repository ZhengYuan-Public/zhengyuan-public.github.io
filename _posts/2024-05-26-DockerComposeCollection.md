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

### Install Web-UI

```shell
docker exec -it <container_id> bash

# Download from github
wget https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control-cn.sh
# or gitee
wget https://gitee.com/culturist/transmission-web-control/raw/master/release/install-tr-control-gitee.sh

sh install-tr-control-cn.sh
# sh install-tr-control-gitee.sh
```

### Some useful path

```shell
# Path inside container
/config/resume
/config/torrents
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
    network_mode: 'host'
    volumes:
      - /share/Container/jellyfin/config:/config
      - /share/Container/jellyfin/cache:/cache
      - /share:/media               # Change to your media path
    extra_hosts:
      - 'host.docker.internal:host-gateway'
    devices:
      - /dev/dri:/dev/dri           # Enable GPU Transcoding
    restart: 'unless-stopped'
    stdin_open: true                # Enable stdin
    tty: true                       # Allocate a pseudo-TTY
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
      - "4000:4000"
    restart: unless-stopped
    stdin_open: true          # Enable stdin
    tty: true                 # Allocate a pseudo-TTY
```
