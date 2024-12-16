# TODO refactor these 2 lines
uri = URI.parse("redis://root:HPZy1uewryYCZeO8CW5z@localhost:6379/")
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

Players::Application.configure do
  config.time_zone = 'Central Time (US & Canada)'
  # Settings specified here will take precedence over those in config/application.rb
  $stdout.sync = true

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  #config.assets.compress = true
  config.assets.compress = false

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = false

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH
  config.middleware.use Rack::SslEnforcer, :only => '/payments'
  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  # config.logger = Logger.new(STDOUT)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  config.action_controller.asset_host = "https://www.idigitallsports.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += %w( application-app.css application-website.css application-app.js application-website.js bootstrap-wysihtml5/wysiwyg-color.css email.css*)

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Set mailer's default url
  config.action_mailer.default_url_options = { :host => "www.idigitallsports.com", :protocol => 'https' }
  
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      :address => "smtp.sendgrid.net",
      :port => 587,
      :domain => "www.idigitallsports.com",
      :authentication => :plain,
      :user_name => "cubetaj",
      :password => "Lifeisgood!14",
      :enable_starttls_auto => true
  }
  # config.action_mailer.default_url_options = { :host => "idigitallsports.com" }

  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   :address   => "smtp.mandrillapp.com",
  #   :port      => 587,
  #   :user_name => 'jamie.fssc@gmail.com',
  #   :password  => 'LgzLydEPFM851qcAFP7nJg',
  #   :domain    => 'idigitallsports.com'
  # }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
