# frozen_string_literal: true

source "https://rubygems.org"

gem "jekyll-theme-chirpy", ">= 7.3.0", "<= 7.3.1"

group :test do
  gem "html-proofer", "~> 5.0"
end

group :jekyll_plugins do
  gem "jemoji"
  gem "jekyll-pdf-embed"
  # gem "jekyll-admin"
  gem "jekyll-scholar"
  gem "jekyll-latex"
  gem 'jekyll-asciinema'
end

# Windows and JRuby does not include zoneinfo files, so bundle the tzinfo-data gem
# and associated library.
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Performance-booster for watching directories on Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` gem to `v0.6.x` on JRuby builds since newer versions of the gem
# do not have a Java counterpart.
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]

gem "webrick", "~> 1.8"
gem 'rack'
gem 'rackup'

gem 'csv'
gem 'observer'