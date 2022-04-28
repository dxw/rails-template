# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "2.7.4"

gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap", ">= 4.3.1"
gem "cssbundling-rails", "~> 1.1"
gem "high_voltage"
gem "jbuilder", "~> 2.11"
gem "jsbundling-rails", "~> 1.0"
gem "lograge", "~> 0.12"
gem "pg"
gem "pry-rails"
gem "mini_racer"
gem "puma", "~> 5.6"
gem "rollbar"
gem "rails", "~> 7.0.2.3"
gem "sprockets-rails"
gem "sass-rails", "~> 6.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "uglifier", ">= 1.3.0"

group :development do
  gem "better_errors"
  gem "listen", ">= 3.0.5", "< 3.8"
  gem "rails_layout"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "brakeman"
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "standard"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "database_cleaner"
  gem "launchy"
  gem "selenium-webdriver"
  gem "simplecov"
  gem "climate_control"
end
