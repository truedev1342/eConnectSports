require_relative 'boot'

require 'rails/all'

# Aweber config, needed before the initializers run.
AWEBER = YAML.safe_load(File.read(File.expand_path('../aweber.yml', __FILE__)))
AWEBER.symbolize_keys!

Bundler.require(*Rails.groups)

module Players
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.load_defaults 7.0

    # 7.0 switches signed/encrypted cookie key derivation to SHA256, which
    # invalidates every existing session and "remember me" cookie. Stay on SHA1
    # for one release so users are not all signed out by the deploy, then drop
    # these two lines.
    config.active_support.key_generator_hash_digest_class = OpenSSL::Digest::SHA1

    config.encoding = 'utf-8'

    # Disable logging of passwords.
    config.filter_parameters += [:password, :password_confirmation]

    config.i18n.enforce_available_locales = false

    # Background work runs through Resque.
    config.active_job.queue_adapter = :resque
  end
end
