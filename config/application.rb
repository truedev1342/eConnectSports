require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

# Aweber newsletter credentials. Kept as a top-level constant because the
# registrations controller has always read it that way.
AWEBER = {
  consumer_key: ENV['AWEBER_CONSUMER_KEY'],
  consumer_secret: ENV['AWEBER_CONSUMER_SECRET'],
  access_token: ENV['AWEBER_ACCESS_TOKEN'],
  access_token_secret: ENV['AWEBER_ACCESS_TOKEN_SECRET'],
  list_id: ENV['AWEBER_LIST_ID']&.to_i
}.freeze

module Players
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults 8.1

    config.encoding = 'utf-8'

    # Disable logging of passwords.
    config.filter_parameters += [:password, :password_confirmation]

    config.i18n.enforce_available_locales = false

    # Background work runs through Resque.
    config.active_job.queue_adapter = :resque
  end
end
