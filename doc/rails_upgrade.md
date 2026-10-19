Rails upgrade notes
===================

This application started on Rails 3.2 and now runs on Rails 8.1. The notes below
record what changed and what is still outstanding.

Framework defaults
------------------

`config.load_defaults` was raised in steps rather than in one jump, so each set
of behaviour changes could be looked at on its own: 5.0 -> 6.1 -> 7.0 -> 7.2 ->
8.0 -> 8.1.

Two defaults needed staging because they affect live traffic:

- **Cookie key derivation.** Rails 7.0 derives signed and encrypted cookie keys
  with SHA256. Flipping it invalidates every session and "remember me" cookie, so
  SHA1 was pinned for one release and then removed.
- **Cookie serializer.** Moved `:marshal` -> `:hybrid` -> `:json` so cookies
  written by the old code kept working through the transition, and Marshal
  deserialization of cookie data was dropped at the end.

APIs that had been removed from the framework
---------------------------------------------

The application was running on Rails 7.2 but still used a number of calls that
had been deleted several majors earlier, so these paths raised at runtime:

- `update_attributes` (removed in 6.1) -> `update`
- `redirect_to :back` (removed in 5.0) -> `redirect_back(fallback_location:)`
- `ActionMailer` `.deliver` (removed in 5.0) -> `.deliver_now`
- `config.secret_token` (removed in 5.2) -> `secret_key_base` from the environment
- `serve_static_files`, `static_cache_control`, `whiny_nils`,
  `best_standards_support`, `assets.compress`, `assets.enabled`,
  `assets.initialize_on_precompile` -> deleted from the environment files
- `cache_classes` -> `enable_reloading`
- `meta_search`'s `Model.search` -> Ransack
- `ActionDispatch::PerformanceTest` (removed in 4.0) -> test deleted

Strong parameters
-----------------

Controllers already had `*_params` methods but the actions still passed raw
`params[:model]` into `new`/`update`, which raises `ForbiddenAttributesError`.
Every call site now goes through the permitted-parameter method.

Zeitwerk
--------

Required before the 6.0 defaults could be enabled:

- `LogoHelper` was defined inside `app/mailers/mailer_base.rb`; moved to
  `app/helpers/logo_helper.rb`.
- `MailerBase` renamed to `ApplicationMailer` to match the file it lives in.
- `config/initializers/active_admin.rb` called `require 'admin_footer'` for an
  autoloadable file and captured the class at boot. It now resolves it inside
  `to_prepare`.
- `config/initializers/error_messages_helper.rb`'s `FormBuilder` patch came from
  a reloadable file; the helper was unused and was removed.

Data model corrections
----------------------

- `Card belongs_to :public_page` had no `public_page_id` column. The foreign key
  is `public_pages.card_id`, so the association was inverted: `Card has_one
  :public_page` and `PublicPage belongs_to :card`.
- `belongs_to` is required by default from the 5.0 defaults onward. Associations
  that are legitimately empty are now `optional: true`: guest cards have no user
  or membership, promo codes have no user until redeemed, activity rows are
  recorded for signed-out visitors, and the child rows created by
  `Payment#purchase` carry no card.
- Card detail rows (phones, emails, websites, socials, stats, shares, contacts)
  were orphaned when a card was destroyed; they are now `dependent: :destroy`.

Bugs found while upgrading
--------------------------

- `sanitized_url` read `url.starts_with? 'http://' || 'https://'`, which Ruby
  evaluates as `starts_with?('http://')`. `https://` URLs came back as
  `http://https://example.com`. Extracted to `SanitizableUrl` and fixed.
- `VcardMailer#send_vcard` and `CardsController#vcard` both read `address1`,
  `address2`, `state`, `zip_code`, `business_name` and `title`, none of which are
  columns on `cards`. Both raised `NoMethodError`. Replaced with `Card#to_vcard`.
- `StaticPagesController#send_mail` redirected to `contact_path`, but the route
  is named `contact_us`, so submitting the contact form raised after the mail
  had been sent.
- `Notifications#new_signup` called `user.user_agent.include?` on a nullable
  column, and `#contact` built its subject with `"literal" << params[:subject]`,
  which raises on a missing subject.
- `config/initializers/kaminari.rb` configured a gem that is not in the Gemfile,
  which raised `NameError` during boot.
- `User` validated `:username` uniqueness with `:case_sensitve` (typo), so the
  option was silently ignored.
- The team payment views rendered `team_payment.transaction`, which is
  `ActiveRecord`'s own method rather than the `transaction_number` column.
- `rescue Exception` in the payment models swallowed `NoMethodError` and reported
  it to users as "There was a problem with your credit card."

Tests
-----

The suite could not run at all: three fixture files referenced columns that do
not exist (`cards.city/state/zip_code/title/address1/address2`,
`shares.sharer_id`, `team_payments.transaction`), so `fixtures :all` failed
before any test executed. Fixtures were rewritten against the real schema and
now build a coherent graph of users, teams, memberships, cards and payments.

`test/unit` and `test/functional` were moved to `test/models`,
`test/controllers`, `test/mailers` and `test/helpers`. The scaffold-era
controller tests used the pre-Rails-5 positional request form (`get :show, id: 1`)
and were rewritten as integration tests that sign in through Devise.

Dependencies
------------

- `sass-rails ~> 5.0` constrains `railties` below 6, so the Gemfile could not
  resolve against Rails 7.2 at all. Replaced with `sassc-rails`.
- Removed gems nothing referenced: `cancan` (no `Ability` class and no
  authorization calls anywhere), `delayed_job_active_record`, `google-api-client`,
  `httparty`, `mini_magick`, `test-unit`, `mocha`, `rspec-rails` (no `spec/`),
  `factory_bot_rails` (no factories), `actionpack-action_caching`,
  `resque_mailer`, `bootstrap_form`, `nifty-generators`, `awesome_pry`,
  `colorize`, and `rvm-capistrano` (Capistrano 2 only).
- `fog` pulled in every cloud provider; only AWS is used, so it is now `fog-aws`.
- `uglifier` cannot parse ES6; replaced with `terser`.
- `rack-ssl-enforcer` (unmaintained since 2013) replaced with `config.force_ssl`.
- Exact pins on `nokogiri`, `loofah` and `rails-html-sanitizer` were relaxed so
  security releases can be picked up.
- `ransack` and `sprockets-rails` are now declared explicitly instead of being
  relied on transitively.

Deployment
----------

`config/deploy.rb` and `config/recipes/` were Capistrano 2 (`run`, `sudo`, `put`,
per-task `roles:`, `callbacks`) while the Gemfile had Capistrano 3, and the file
still required `rvm/capistrano` from a gem that is no longer installed. The
config was rewritten for Capistrano 3 with rbenv, and the Capistrano 2 recipe
collection was removed. Credentials are delivered through `linked_files` rather
than a checked-in sample.

Secrets removed from the repository
-----------------------------------

`config/initializers/secret_token.rb`, `config/fog_credentials.yml` and
`config/aweber.yml` all held live credentials, and the SMTP password and Redis
password were hardcoded in the environment files. These now come from the
environment.

**These credentials are still in the git history and must be rotated:** the
Rails secret token, AWS access keys, the SendGrid SMTP password, the Redis
password, and the AWeber API keys.

Verified running
----------------

The upgrade was run end to end on Ruby 3.4.2 / Rails 8.1.0 against PostgreSQL
and Redis:

- `bundle install` resolves and installs (190 gems).
- The app boots, `db:schema:load` and `db:migrate` run clean.
- `bin/rails test` is green: 316 runs, 625 assertions, 0 failures, 0 errors.
- `RAILS_ENV=production bin/rails assets:precompile` writes 603 files; terser
  minifies application-app.js from 1.12 MB to 530 KB and sassc compiles the SCSS.
- Puma serves the site; sign-in, dashboard, teams, contacts, invites, the card
  page, the payment form, the ActiveAdmin login and the vCard download all
  return 200, and the vCard contains the expected name/org/title.

Problems found by actually running it
-------------------------------------

- **minitest 6 breaks the Rails 8.1 test runner.** `activesupport` allows
  `minitest >= 5.1` with no ceiling, so bundler picked 6.0.6, whose
  `Runnable.run_suite` passes three arguments to `Rails::LineFiltering#run`,
  which takes two. Pinned to `~> 5.25`.
- **`sass-rails ~> 5.0` made the Gemfile unresolvable**, which is why the
  repository had no lockfile. Replaced with `sassc-rails`.
- **`Gemfile.lock` was gitignored.** An application has to commit it or CI and
  production resolve different gem versions. Now tracked.
- **No `.env.test`**, so moving `database.yml` to environment variables left the
  test environment with no database credentials.
- **A live Stripe secret key was committed** in
  `config/initializers/stripe.rb`. Moved to `STRIPE_SECRET_KEY`.
- **`TeamPaymentsController` had no authentication at all** - its index listed
  every customer's email and Stripe customer token publicly.
- **Share ownership came from a hidden `user_id` form field.** Creation failed
  whenever the field was missing, and it could be forged when present. The
  controller now assigns `current_user`.
- **`UserMailer#password_reset` was dead and broken**, calling
  `@user.password_reset_token` (Devise's column is `reset_password_token`) and
  `edit_password_reset_url`, which is not a route. Devise sends its own reset
  mail; both the action and its view were removed.
- **Top-level card and membership member routes had been deleted** while the
  views and controllers still called `vcard_card_path`,
  `approve_membership_path`, `edit_membership_card_path` and friends. Restored.
- **`TeamsController#index` had no template.**
- **Promo redemption crashed before it ran.** `Payment#create` built
  `Payment.new(payment_params)` before the promo branch, so a promo-only
  submission raised `ActionController::ParameterMissing`.
- **`TeamPayment` required `stripe_card_token` on every save**, so any later
  edit of a persisted payment was invalid. Now only required for a new record.
- **`formtastic-bootstrap` (last released 2015) calls `Formtastic::Util`**,
  removed in Formtastic 6. It styled a single form, which is now a plain
  `form_with`, and the gem was dropped.
- Several views called methods on possibly-nil associations
  (`m.card.image?`, `@card.image?`, `admincard`, `@card.image_url` in the share
  mailer) and a polymorphic `contact` with no `contact_path`.
- `CarrierWave#fog_provider` is deprecated in CarrierWave 3 and had no effect.

Devise 5
--------

`devise_for` in Devise 4.9 passed a hash to `resource`, which Rails 8.2 will
reject, so Devise was moved to 5.0 (devise_invitable allows `devise >= 4.6`).
Devise 5 removed `devise_error_messages!`; the eight views that called it now
render `devise/shared/error_messages`. The application boots with no deprecation
warnings.

Content Security Policy
-----------------------

The policy is now enforced rather than report-only, with `script-src` on a nonce
and no `'unsafe-inline'`:

- The 31 inline `onClick="window.open(...)"` social share handlers became
  `class="js-share-popup" data-share-url="..."` plus one delegated listener in
  `app/assets/javascripts/share_popup.js`. Inline handlers are the one thing a
  nonce cannot allow, so they were the blocker.
- All 38 inline `<script>` blocks carry `nonce="<%= content_security_policy_nonce %>"`.
- Four pre-HTML5 `onfocus`/`onblur` placeholder emulations on the contact form
  were removed; the fields already have real `placeholder` attributes.
- `style-src` keeps `'unsafe-inline'`: many views use `style="..."` attributes,
  which a nonce cannot cover.

`test/integration/content_security_policy_test.rb` asserts the policy is
enforced, that the header and body nonces match, that no page carries an inline
handler, and that every inline script is nonced - so a reintroduced handler fails
CI rather than silently breaking in a browser.

Containers
----------

`Dockerfile` (multi-stage) and `docker-compose.yml` run the app, PostgreSQL,
Redis, a Resque worker and the Resque scheduler. Two code changes were needed:

- `puma` was in the `:development` group, so a production image had no TCP app
  server (`config/unicorn.rb` listens on a unix socket for the nginx deploy).
  Puma is now a top-level dependency; unicorn is untouched.
- `config.force_ssl` / `config.assume_ssl` were hardcoded to true, which
  301-redirects every plain HTTP request. They now read `RAILS_FORCE_SSL` /
  `RAILS_ASSUME_SSL` and still default to true, so the nginx deploy is unchanged.

Verified by building and running the stack: the 482 MB image builds, `db:prepare`
runs from the entrypoint (25 tables), pages and digested assets are served, CSP
is still enforced, `bin/rails test` passes inside the container (316 runs), and a
`NotifyCardExpirationJob` enqueued on the `notify_card` queue was picked up by
the worker within five seconds. `procps` is installed in the runtime stage
because Resque shells out to `ps` to prune dead workers.

Still outstanding
-----------------

- **Stripe charging is still mocked.** `Payment#purchase` and
  `TeamPayment#purchase` set `mock_stripe_customer_...` / `MOCK_TRANSACTION_...`
  instead of calling Stripe, and the real calls sit commented out. They cannot
  simply be uncommented: the commented code uses
  `Stripe::Customer.create(card: token)` and `Stripe::Charge.create`, and the
  installed gem (19.x) pins API version `2026-06-24.dahlia`, where raw card
  tokens on customers are gone and charging goes through PaymentIntents. Doing
  this properly means client-side Stripe Elements, PaymentIntents with SCA
  handling, and webhooks - a payments project needing real keys and a test
  account, not a mechanical edit. Deliberately left alone rather than shipped
  untested.
- **Sprockets is still 3.7 with `sassc-rails`.** This works: assets compile in
  development and `assets:precompile` succeeds in production. But `sassc-rails`
  is unmaintained, so moving to `dartsass-sprockets` with Sprockets 4 is worth
  doing eventually. It needs `app/assets/config/manifest.js` and the 19
  `.css.scss` / 17 `.js.coffee` files renamed, so it is a standalone piece of
  work rather than part of the version bump.
- The `vpim` gem emits "literal string will be frozen" warnings on Ruby 3.4.
- Google+ share links remain in the views; that service shut down in 2019.
