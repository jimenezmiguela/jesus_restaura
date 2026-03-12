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

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}

# Install system dependencies (no Node/Yarn needed)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      pkg-config \
      libpq-dev \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.6.9 && bundle install

# Copy app
COPY . .

# Precompile
RUN bundle exec bootsnap precompile
RUN bin/rails assets:precompile

# -------- FINAL STAGE --------
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq5 \
      postgresql-client \
      curl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp db

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
