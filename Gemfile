source 'https://rubygems.org'
ruby '2.1.5'

# Require Sinatra and JSON for back-end
gem 'sinatra', '~> 1.4.5'
gem 'json',    '~> 1.8.1'
gem 'rack-cors', '~> 0.4', require: 'rack/cors'

# Use Thin web server
gem 'thin', '~> 1.6.2'

# Use Slogger as middleware to integrate with syslog
gem 'slogger', '~> 0.0', '>= 0.0.10'

# Use Sequel ORM tool
gem 'sequel',  '~> 4.21'
gem 'mysql2', '~> 0.3', '>= 0.3.16'
gem 'rake',    '~> 10.4'

# Use ReactiveSupport to provide utility methods
gem 'reactive_support', '~> 0.5.0'
gem 'reactive_extensions', '~> 0.5.0'

# Use Cucumber and RSpec for testing
# Coveralls and SimpleCov monitor test coverage
group :test do 
  gem 'simplecov',          '>= 0.10.0'
  gem 'coveralls',          '>= 0.8.1'
  gem 'json_spec',          '~> 1.1.2'
  gem 'cucumber-sinatra',   '~> 0.5.0'
  gem 'cucumber',           '~> 1.3.16'
  gem 'capybara',           '~> 2.4.4'
  gem 'capybara-webkit',    '~> 1.5.1'
  gem 'rspec',              '~> 3.0'
  gem 'rack-test',          '~> 0.6.2', require: 'rack/test'
  gem 'factory_girl',       '~> 4.4'
  gem 'colorize',           '~> 0.7.7' # for Rake output
end