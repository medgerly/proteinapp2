source "https://rubygems.org"

gem "rails", "~> 8.0.2"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false

gem "kamal", require: false
gem "thruster", require: false

# Auth & Authorization
gem "devise"
gem "pundit"

# Forms & UI
gem "simple_form"
gem "active_link_to"
gem "pagy"
gem "kaminari"

# Search
gem "ransack"

# File upload & image
gem "carrierwave"
gem "cloudinary"

# Data helpers
gem "strip_attributes"
gem "validate_url"
gem "faker"

# HTTP & AI
gem "http"
gem "ai-chat"
gem "appdev_support"

# Utilities
gem "dotenv"
gem "rollbar"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 7.1.1"
  gem "grade_runner", "~> 0.0.13"
  gem "faker"
end

group :development do
  gem "web-console"
  gem "annotaterb"
  gem "better_errors"
  gem "binding_of_caller"
  gem "dev_toolbar", "~> 2.1.0"
  gem "draft_generators", github: "firstdraft/draft_generators", branch: "bp-summer-2025-update"
  gem "haikunator"
  gem "pry-rails"
  gem "rails_db", "~> 2.5.0"
  gem "rails-erd"
  gem "rufo"
  gem "awesome_print"
  gem "htmlbeautifier"
end

group :test do
  gem "shoulda-matchers", "~> 6.4"
  gem "rspec-html-matchers"
  gem "rails-controller-testing"
  gem "webmock"
  gem "capybara"
  gem "selenium-webdriver", "~> 4.11.0"
end
