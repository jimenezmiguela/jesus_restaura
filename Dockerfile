# syntax = docker/dockerfile:1

# Match Ruby version with .ruby-version and Gemfile
ARG RUBY_VERSION=2.7.6
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# --- Build Stage ---
FROM base as build

# Install packages needed to build gems, including PostgreSQL support
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    pkg-config \
    libpq-dev

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap files for faster boot time
RUN bundle exec bootsnap precompile app/ lib/

# Precompile Rails assets without needing real secret
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# --- Final Runtime Stage ---
FROM base

# Install only runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy compiled app and gems from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails log tmp
USER rails:rails

# Entrypoint handles database setup
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Default command: start Rails server
EXPOSE 3000
CMD ["./bin/rails", "server"]
