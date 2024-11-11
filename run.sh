[ -d "_site" ] && rm -r _site
bundle exec jekyll serve --host=0.0.0.0 --incremental
