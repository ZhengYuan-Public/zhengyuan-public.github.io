---
comments: true
title: DDNS with DuckDNS
date: 2024-02-09 12:00:00
image:
    path: /assets/img/images_preview/DuckDNSPreview.png
math: true
categories: [Virtualization, Docker]
tags: [virtulization, proxmox, docker, ddns, network]
---

## DuckDNS

Register an account @[duckdns.org](https://www.duckdns.org/) and add your own subdomain. Take notes of the subdomain (without the `duckdns.org` suffix) and token.

## Install with Docker Compose

```bash
$ mkdir duckdns
$ cd duckdns
$ nano compose.yml
```

```yml
---
services:
  duckdns:
    image: lscr.io/linuxserver/duckdns:latest
    container_name: duckdns-dc
    network_mode: host #optional
    environment:
      - PUID=1000 #optional
      - PGID=1000 #optional
      - TZ=Etc/UTC #optional
      - SUBDOMAINS={YOUR_SUBDOMAIN_HERE} # Without the "duckdns.org" suffix
      - TOKEN={YOUR_TOKEN_HERE}
      - UPDATE_IP=ipv4 #optional
      - LOG_FILE=false #optional
    volumes:
      - /path/to/duckdns/config:/config #optional
    restart: unless-stopped
```

```bash
# Start the docker container
$ docker compose up -d

# Check logs
$ docker logs duckdns-dc
```

