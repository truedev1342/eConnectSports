I Dig It All Sports
===================

Rails application behind the I Dig It All Sports digital trading cards site.
Users build player cards, share them, collect contacts, and organise cards into
teams.

Stack
-----

- Ruby 3.4 (see `.ruby-version`)
- Rails 8.1
- PostgreSQL
- Redis + Resque for background jobs (via Active Job)
- Sprockets asset pipeline with SCSS
- Devise for authentication, ActiveAdmin for the admin area
- Stripe and PayPal for payments, CarrierWave + S3 for uploads

Getting started
---------------

    bin/setup

`bin/setup` installs gems and prepares the database. Configuration comes from
the environment; `dotenv` loads `.env.development` in development.

Required environment variables
------------------------------

Nothing secret is committed to this repository. The following need to be set:

| Variable | Used for |
| --- | --- |
| `SECRET_KEY_BASE` | Signing cookies (production) |
| `DATABASE_HOST`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`, `DATABASE_NAME` | PostgreSQL connection |
| `REDIS_URL` | Resque queues |
| `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USER_NAME`, `SMTP_PASSWORD` | Outbound mail |
| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | CarrierWave uploads to S3 |
| `AWEBER_CONSUMER_KEY`, `AWEBER_CONSUMER_SECRET`, `AWEBER_ACCESS_TOKEN`, `AWEBER_ACCESS_TOKEN_SECRET`, `AWEBER_LIST_ID` | Newsletter signup |
| `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY` | Card payments |
| `RAILS_LOG_LEVEL`, `RAILS_LOG_TO_STDOUT`, `RAILS_SERVE_STATIC_FILES` | Logging and static files |

Running the app
---------------

    bin/rails server              # web
    bundle exec rake resque:work  # background jobs

Docker
------

`docker-compose.yml` brings up the app, PostgreSQL, Redis, a Resque worker and
the Resque scheduler.

    cp .env.docker.example .env.docker
    docker compose build
    docker compose run --rm web bin/rails secret     # paste into SECRET_KEY_BASE
    docker compose up -d
    open http://localhost:3000

The web container prepares the database on boot (`DB_PREPARE=true` runs
`db:prepare` once PostgreSQL is reachable), so no separate setup step is needed.

Useful commands:

    docker compose logs -f web
    docker compose exec web bin/rails console
    docker compose exec web bin/rails db:migrate
    docker compose run --rm -e RAILS_ENV=test -e DB_PREPARE=false web bin/rails db:test:prepare
    docker compose run --rm -e RAILS_ENV=test -e DB_PREPARE=false web bin/rails test
    docker compose down                              # stop
    docker compose down -v                           # stop and drop the volumes

Notes:

- The image is built for `RAILS_ENV=production` and assets are precompiled into
  it, so a rebuild is needed after changing assets. There is no source bind mount.
- `RAILS_FORCE_SSL=false` and `RAILS_ASSUME_SSL=false` are set in
  `.env.docker.example` so the container is reachable over plain HTTP. Remove
  them (or set them to `true`) once TLS terminates in front of it, otherwise the
  app will not issue the HTTPS redirect it does in the nginx deployment.
- `RAILS_SERVE_STATIC_FILES=1` lets Puma serve the precompiled assets. Behind a
  reverse proxy, drop it and let the proxy serve `public/`.
- Uploads go to S3 via CarrierWave. The `uploads` volume only covers
  `public/system`, so set `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` for
  uploads to work.
- `.env.*` is excluded from the image (see `.dockerignore`); the committed
  `.env.production` holds stale values, so configuration comes from
  `.env.docker` via compose instead.
- Assets are served under their digested filenames in production. Requesting
  `/assets/application-website.css` returns 404 by design; the page references
  `/assets/application-website-<digest>.css`.
- Background jobs need `SMTP_USER_NAME` / `SMTP_PASSWORD`. Without them
  `NotifyCardExpirationJob` runs, queries and renders correctly, then fails at
  the send with `Net::SMTPAuthenticationError`.

Tests
-----

    bin/rails test                # everything (316 runs, 625 assertions)
    bin/rails test test/models    # one directory

Tests are Minitest with fixtures, laid out under `test/models`,
`test/controllers`, `test/mailers`, `test/helpers` and `test/jobs`. CI runs the
same suite against PostgreSQL and Redis (see `.github/workflows/ci.yml`).

Background jobs
---------------

`NotifyCardExpirationJob` warns card owners a week before expiry and again once
a card has lapsed. It is scheduled from `config/schedule.rb` (whenever) and runs
on the `notify_card` Resque queue.

Upgrade history
---------------

See `doc/rails_upgrade.md` for the path from Rails 3.2 to 8.1 and the work that
is still outstanding.
