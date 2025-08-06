# syntax = docker/dockerfile:1

ARG RUBY_VERSION=2.7.6
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# -------- BUILD STAGE --------
FROM base AS build

# Accept RAILS_MASTER_KEY as build argument
ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    libpq-dev \
    nodejs \
    yarn \
    curl

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application source code
COPY . .

# Precompile app code (requires RAILS_MASTER_KEY to be set in Dokku)
RUN bundle exec bootsnap precompile app/ lib/
RUN ./bin/rails assets:precompile

# -------- FINAL STAGE --------
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq5 \
    postgresql-client \
    curl && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy everything from build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Set ownership and permissions
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp db

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["./bin/rails", "server"]
