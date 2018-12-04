# frozen_string_literal: true

source 'https://rubygems.org'
# source 'http://mirror.ops.rhcloud.com/mirror/ruby/'
ruby '2.5.3'

# PRESENTATION LAYER
gem 'multi_json'
gem 'roar'

# APPLICATION LAYER
# Web application related
gem 'econfig', '~> 2.1'
gem 'puma', '~> 3.11'
gem 'rack-cache', '~> 1.8'
gem 'redis', '~> 4.0'
gem 'redis-rack-cache', '~> 2.0'
gem 'roda', '~> 3.8'

# Controllers and services
gem 'dry-monads'
gem 'dry-transaction'
gem 'dry-validation'

# DOMAIN LAYER
gem 'dry-struct', '~> 0.5'
gem 'dry-types', '~> 0.5'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 3.0'

# Database
gem 'hirb', '~> 0.7'
gem 'sequel', '~> 5.13'

group :development, :test do
  gem 'database_cleaner'
  gem 'sqlite3'
end

group :production do
  gem 'pg', '~> 0.18'
end

# DEBUGGING
group :development, :test do
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

# TESTING
group :test do
  gem 'minitest', '~> 5.11'
  gem 'minitest-rg', '~> 5.2'
  gem 'simplecov', '~> 0.16'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.4'
end

gem 'rack-test' # can also be used to diagnose production

# QUALITY
group :development, :test do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# UTILITIES
gem 'pry'
gem 'rake', '~> 12.3'
gem 'travis'

group :development, :test do
  gem 'rerun'
end
