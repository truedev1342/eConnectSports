source 'https://rubygems.org'

gem 'rails', '4.0.13'

# Bundle edge Rails instead:

# database connection
gem 'pg', '~> 0.11'

# web server
gem 'unicorn'
gem 'nokogiri', '1.8.5'
gem 'multipart-post', '2.0.0'
# Generators / DSLs
gem 'nifty-generators', :group => :development
gem 'delayed_job_active_record'
# Authentication
gem 'devise',           '>= 2.0.0'
gem 'devise_invitable', '~> 1.1.0'
gem 'cancan'
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
#gem 'icalendar'
#gem 'ri_cal'

# In place editing
gem 'best_in_place'

# Pagination
gem 'will_paginate'

# Search
gem 'meta_search'

# Administration
gem "formtastic", "~> 2.1.1"
# Easy Forms
gem "activeadmin"

# Payments
gem 'stripe'
gem 'paypal-recurring'

# Twitter Bootstrap
gem 'execjs', '~> 1.4.0'
gem 'twitter_bootstrap_form_for'
gem 'bootstrap-wysihtml5-rails'
gem 'formtastic-bootstrap'
gem 'bootstrap-colorpicker-rails'
gem 'font-awesome-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sprockets', '~> 2.2.2'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Deploy with Capistrano
group  :development do
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
gem "capistrano-resque", '~> 0.1.0', require: false
gem 'resque_mailer'

gem "mocha", :group => :test
gem 'aweber'
group :development, :test do
  gem 'rspec-rails'
end

# email styles
gem 'premailer-rails'

#regular jobs
gem 'whenever'

gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'