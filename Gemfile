# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'
gem "aasm", "~> 5.4"
gem 'aws-sdk-s3', require: false
gem "babosa", "~> 2.0"
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bootstrap', '~> 5.2.2'
gem 'dartsass-rails', '~> 0.4.0'
gem 'devise', '~> 4.8'
gem 'friendly_id', '~> 5.4.0'
gem 'image_processing'
gem 'jbuilder', '~> 2.7'
gem 'net-smtp', require: false
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'paranoia', '~> 2.6'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.7'
gem 'rails-i18n'
gem 'redis'
gem 'sidekiq', '~> 7.0', '>= 7.0.1'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'webpacker', '~> 5.0'
gem 'will_paginate', '~> 3.3'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'
  gem 'foreman', '~> 0.87.2'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rubocop', '~> 1.39', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'webdrivers'
end
