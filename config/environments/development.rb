Rails.application.configure do
  # Match production so date/time formatting behaves the same in development.
  config.time_zone = 'Central Time (US & Canada)'

  # Settings specified here will take precedence over those in config/application.rb
  $stdout.sync = true

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.active_storage.service = :local
  config.action_mailer.perform_caching = false

  # Set mailer's default url
  config.action_mailer.default_url_options = { host: 'localhost:3000', protocol: 'https' }

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

  config.action_mailer.asset_host = 'http://localhost:3000'

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # Expands the lines which load the assets
  config.assets.debug = true
  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  BetterErrors.maximum_variable_inspect_size = 10_000_000 if defined?(BetterErrors)
end
