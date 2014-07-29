source 'https://rubygems.org'

# Require Sinatra and JSON for back-end
gem 'sinatra', '~> 1.4.5'
gem 'json',    '~> 1.8.1'

# Use Thin web server
gem 'thin', '~> 1.6.2'

# Use ActiveRecord and SQLite 3 to manage DB records
gem 'sinatra-activerecord', '~> 2.0.2'
gem 'activerecord',         '>= 4.1.3'
gem 'acts_as_list',         '~> 0.4.0'
gem 'sqlite3',              '~> 1.3.9', :platform => :ruby
gem 'rake',                 '~> 10.3.2'

# Use Sinatra-Backbone for the RestAPI module to prepare for integration
# with Backbone.js front-end
gem 'sinatra-backbone', '~> 0.1.1', :require => 'sinatra/backbone'

# User OmniAuth for user logins
gem 'omniauth',               '~> 1.2.2'
gem 'omniauth-facebook',      '~> 1.6.0'
gem 'omniauth-tumblr',        '~> 1.1.0'
gem 'omniauth-twitter',       '~> 1.0.1'
gem 'omniauth-google-oauth2', '~> 0.2.5'
gem 'omniauth-instagram',     '~> 1.0.1'
gem 'omniauth-identity',      '~> 1.1.1'

# Use Cucumber, RSpec, Webmock for testing
group :test do 
  gem 'codeclimate-test-reporter', require: nil
  gem 'json_spec',        '~> 1.1.2'
  gem 'cucumber-sinatra', '~> 0.5.0'
  gem 'cucumber',         '~> 1.3.11'
  gem 'rspec',            '~> 3.0.0'
  gem 'rack-test',        '~> 0.6.2', require: 'rack/test'
  gem 'factory_girl',     '~> 4.4.0'
  gem 'database_cleaner', '~> 1.3.0'
end

# Use require_all to clean up requires
gem 'require_all', '~> 1.3.2'
