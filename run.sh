[ -d "_site" ] && rm -r _site
[ -d ".jekyll-cache" ] && rm -r .jekyll-cache
bundle exec jekyll serve --host=0.0.0.0 --incremental
