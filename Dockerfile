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