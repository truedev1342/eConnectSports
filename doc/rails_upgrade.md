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

Still outstanding
-----------------

- **Asset pipeline.** Still on `sprockets ~> 3.7` with `sassc-rails`, which is
  itself unmaintained. Moving to Sprockets 4 needs an
  `app/assets/config/manifest.js` and the 19 `.css.scss` files renamed, or a move
  to `dartsass-sprockets`. Held back because it cannot be verified without
  running an asset precompile.
- **ActiveAdmin** is unpinned. Confirm which release supports Rails 8.1 and pin
  it; ActiveAdmin 4 changes how its assets are built.
- **Content Security Policy** is report-only. Several views use inline handlers,
  so the inline-script allowance has to stay until those are moved into the asset
  pipeline.
- **`Payment#purchase` and `TeamPayment#purchase`** still have their Stripe calls
  commented out and return mock transaction ids.
- The `status` columns on `payments` and `team_payments` are strings while the
  `PROCESSING`/`FAILED`/`SUCCESS` constants are integers, so values round-trip as
  `"1"`, `"2"`, `"3"`.
