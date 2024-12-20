source 'https://rubygems.org'

gem 'rails', '4.2.11.3'

# database connection
gem 'pg', '~> 0.11'

# web server
gem 'unicorn'
gem 'nokogiri', '1.10.10'
gem 'multipart-post', '2.0.0'
gem 'loofah', '2.3.0'
gem 'rails-html-sanitizer', '1.0.4'
gem 'activerecord-session_store'
gem 'actionpack-action_caching'

# Generators / DSLs
gem 'nifty-generators', :group => :development
gem 'delayed_job_active_record'
# Authentication
gem 'devise',           '~> 3.5'
gem 'devise_invitable'
gem 'cancan'
gem 'omniauth', '~> 1.0'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'google-api-client', '~> 0.9.8', :require => 'google/apis'
gem 'httparty'
gem 'rack-ssl-enforcer'
# Uploads
gem 'carrierwave', '~> 0.7.1'
gem 'fog-ovirt', '1.0.0'
gem 'fog'
gem 'rmagick', require: false

gem 'test-unit'

# Personal Information Management (used for vCard generation)
gem 'vpim'

# In place editing
gem 'best_in_place'

# Pagination
gem 'will_paginate'

# Search
gem 'meta_search'

# Administration
gem 'formtastic', '~> 3.1'
# Easy Forms
gem 'activeadmin'

# Payments
gem 'stripe'
gem 'paypal-recurring'

# Twitter Bootstrap
gem 'execjs', '~> 1.4.0'
# gem 'twitter_bootstrap_form_for'
gem 'bootstrap_form'
gem 'bootstrap-wysihtml5-rails'
gem 'formtastic-bootstrap'
gem 'bootstrap-colorpicker-rails'
gem 'font-awesome-rails'

# Gems used only for assets and not required
# in production environments by default.
gem 'sprockets', '~> 2.8.3'
gem 'sass-rails',   '~> 4.0.5'
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.3.0'
# gem 'twitter-bootstrap-rails'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
group	 :development do
  gem 'capistrano', '~> 2.0'
  gem  'rvm-capistrano',  require: false
  gem 'byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_pry'
  gem 'colorize'
  gem 'puma'
end

gem 'dotenv-rails'

# Queueing
gem 'resque', '~> 1.22.0'
gem 'capistrano-resque', '~> 0.1.0', require: false
gem 'resque_mailer'

# To use debugger
# gem 'debugger'

group :test do
  gem 'mocha'
end
group :development, :test do
  gem 'rspec-rails'
end
gem 'aweber'

# email styles
gem 'premailer-rails'

#regular jobs
gem 'whenever'
gem 'protected_attributes'
