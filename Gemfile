source 'https://rubygems.org'
#source 'http://gems.github.com'

gem 'rails', '3.2.19'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# database connection
#gem 'sqlite3'                                              r
gem 'pg'

# web server
gem 'unicorn'
gem 'nokogiri', '1.8.5'
# Generators / DSLs
gem 'nifty-generators', :group => :development
gem 'delayed_job_active_record'
# Authentication
gem 'devise',           '>= 2.0.0'
gem 'devise_invitable', '~> 1.1.0'
gem 'cancan'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'google-api-client', :require => 'google/api_client'
gem 'httparty'
gem 'rack-ssl-enforcer'
# Uploads
gem 'carrierwave'
gem 'fog'
gem 'rmagick', require: false

gem 'test-unit'
#gem 'mini_magick'

# Personal Information Management (used for vCard generation)
#gem 'vpim'
gem 'vpim', :git => 'git://github.com/xing/vpim.git'
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
gem "activeadmin", github: 'gregbell/active_admin', branch: '0-6-stable'

# Payments
gem 'stripe'
gem 'paypal-recurring'

# Twitter Bootstrap
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

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  # gem 'twitter-bootstrap-rails'

end

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
  gem 'puma' , '~> 2.16'
end

gem 'dotenv-rails'

# Queueing
gem 'resque', '~> 1.22.0'
gem "capistrano-resque", '~> 0.1.0', require: false
gem 'resque_mailer'

# To use debugger
# gem 'debugger'

gem "mocha", :group => :test
gem 'aweber'

# email styles
gem 'premailer-rails'

#regular jobs
gem 'whenever'
