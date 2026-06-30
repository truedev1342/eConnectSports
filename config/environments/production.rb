Rails.application.configure do
  config.time_zone = 'Central Time (US & Canada)'
  # Settings specified here will take precedence over those in config/application.rb
  $stdout.sync = true

  # Used to verify signed cookies and encrypted messages. Was hardcoded in
  # config/initializers/secret_token.rb, which used the Rails 3 `secret_token`
  # setting that no longer exists.
  config.secret_key_base = ENV.fetch('SECRET_KEY_BASE')

  # Code is not reloaded between requests.
  config.enable_reloading = false
  config.eager_load = true

  # Never show full error reports in production.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # nginx serves the precompiled assets.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Assets are precompiled at deploy time, so don't compile them on request.
  config.assets.compile = false
  config.assets.js_compressor = :terser

  # nginx terminates TLS in front of the app. Both can be turned off (for a
  # container running behind a proxy that terminates TLS elsewhere, or for local
  # testing over plain HTTP) with RAILS_ASSUME_SSL/RAILS_FORCE_SSL=false.
  config.assume_ssl = ENV.fetch('RAILS_ASSUME_SSL', 'true') != 'false'
  config.force_ssl = ENV.fetch('RAILS_FORCE_SSL', 'true') != 'false'

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = 'https://www.idigitallsports.com'

  config.action_mailer.perform_caching = false

  # Set mailer's default url
  config.action_mailer.default_url_options = { host: 'www.idigitallsports.com', protocol: 'https' }
  config.active_storage.service = :local

  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info').to_sym
  config.log_tags = [:request_id]

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: ENV.fetch('SMTP_ADDRESS', 'smtp.sendgrid.net'),
      port: ENV.fetch('SMTP_PORT', 587).to_i,
      domain: ENV.fetch('SMTP_DOMAIN', 'www.idigitallsports.com'),
      authentication: :plain,
      user_name: ENV['SMTP_USER_NAME'],
      password: ENV['SMTP_PASSWORD'],
      enable_starttls_auto: true
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end
