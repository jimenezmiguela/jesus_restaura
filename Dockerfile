# syntax = docker/dockerfile:1

# Match Ruby version with .ruby-version and Gemfile
ARG RUBY_VERSION=2.7.6
FROM ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Production environment variables
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# --- Build Stage ---
FROM base as build

# Install packages needed to build gems and JS dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    libpq-dev \
    nodejs \
    yarn \
    curl

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy app code
COPY . .

# Precompile bootsnap files and assets
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile && \
    rm -rf tmp/cache vendor/assets

# --- Final Runtime Stage ---
FROM base

# Install only runtime dependencies including PostgreSQL client
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    libpq5 \
    postgresql-client \
    curl && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Copy built app and gems
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create non-root user and fix permissions
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp db

# Switch to non-root user
USER rails:rails

# Entrypoint and default command
ENTRYPOINT ["./bin/rails"]
CMD ["server"]

# Expose port 3000 for web
EXPOSE 3000
