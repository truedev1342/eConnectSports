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
