# Zheng's Website
This is a statis website made with [Jekyll](https://jekyllrb.com/) + [Chirpy Theme](https://github.com/cotes2020/jekyll-theme-chirpy/). 

Click [here](https://zhengyuan-public.github.io) to visit my site.

## Host locally with Docker
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

> Made by Zheng Yuan with :hearts: