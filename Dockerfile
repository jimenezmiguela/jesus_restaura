# syntax = docker/dockerfile:1

# -------- BASE IMAGE --------
ARG RUBY_VERSION=3.1.3
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# -------- BUILD STAGE --------
FROM base AS build

# Accept RAILS_MASTER_KEY as build arg
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

# Install system dependencies, Node.js, npm, and Yarn
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      pkg-config \
      libpq-dev \
      curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    rm -rf /var/lib/apt/lists/*

# Copy Ruby dependencies first to leverage Docker cache
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.6.9 && bundle install

# Copy the rest of the application
COPY . .

# Precompile bootsnap and assets
RUN bundle exec bootsnap precompile
RUN bin/rails assets:precompile

# -------- FINAL STAGE --------
FROM base

# Install only runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq5 \
      postgresql-client \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Copy Ruby gems and app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Set ownership
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp db

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
