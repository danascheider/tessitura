source 'https://rubygems.org'

# Require Sinatra and JSON for back-end
gem 'sinatra', '~> 1.4.5'
gem 'json',    '~> 1.8.1'

# Use Thin web server
gem 'thin', '~> 1.6.2'

# Use ActiveRecord and SQLite 3 to manage DB records
gem 'sinatra-activerecord', '~> 2.0.2'
gem 'sqlite3',              '~> 1.3.9', :platform => :ruby
gem 'rake',                 '~> 10.3.2'

# Use Sinatra-Backbone for the RestAPI module to prepare for integration
# with Backbone.js front-end
gem 'sinatra-backbone', '~> 0.1.1', :require => 'sinatra/backbone'

# Use Cucumber and RSpec with Capybara for testing
group :test do 
  gem 'httparty',         '~> 0.13.1'
  gem 'childprocess',     '~> 0.5.3'
  gem 'json_spec',        '~> 1.1.2'
  gem 'cucumber-sinatra', '~> 0.5.0'
  gem 'cucumber',         '~> 1.3.11'
  gem 'rspec',            '~> 3.0.0'
  gem 'rack-test',        '~> 0.6.2', require: 'rack/test'
  gem 'capybara',         '~> 2.3.0'
  gem 'factory_girl',     '~> 4.4.0'
  gem 'database_cleaner', '~> 1.3.0'
end

# Use require_all to clean up requires
gem 'require_all', '~> 1.3.2'