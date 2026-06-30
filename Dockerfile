# syntax=docker/dockerfile:1

# ---------------------------------------------------------------------------
# Base: Ruby matching .ruby-version, plus the shared libraries the gems link
# against at runtime (libpq for pg, ImageMagick for rmagick).
# ---------------------------------------------------------------------------
ARG RUBY_VERSION=3.4.2
FROM ruby:${RUBY_VERSION}-slim AS base

ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development \
    RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=1 \
    RAILS_SERVE_STATIC_FILES=1

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      libpq5 \
      libmagickwand-6.q16-6 \
      curl \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# ---------------------------------------------------------------------------
# Build: compilers, headers and a JS runtime. Node is needed at build time
# because coffee-rails compiles the .coffee assets and terser minifies the JS.
# ---------------------------------------------------------------------------
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      libmagickwand-dev \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install gems first so this layer is cached until the Gemfile changes.
COPY Gemfile Gemfile.lock .ruby-version ./
RUN bundle install --jobs 4 --retry 3 && \
    rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

RUN bundle exec bootsnap precompile app/ lib/ || true

# Precompiling needs a secret_key_base and a database.yml that parses, but it
# never connects to the database. The value below is used for this step only.
RUN SECRET_KEY_BASE=dummy_key_for_asset_precompile_only \
    bundle exec rails assets:precompile && \
    rm -rf tmp/cache/assets

# ---------------------------------------------------------------------------
# Runtime
# ---------------------------------------------------------------------------
FROM base AS runtime

# Resque shells out to `ps` to prune dead workers.
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y procps && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=build /app /app

# Run unprivileged, but keep the directories the app writes to writable.
RUN groupadd --system --gid 1000 app && \
    useradd --system --uid 1000 --gid 1000 --create-home app && \
    mkdir -p log tmp/pids tmp/cache tmp/sockets storage public/system && \
    chown -R app:app log tmp storage public/system
USER app:app

EXPOSE 3000

COPY --chown=app:app bin/docker-entrypoint /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
