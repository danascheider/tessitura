source 'https://rubygems.org'
ruby '2.1.3'

# Require Sinatra and JSON for back-end
gem 'sinatra', '~> 1.4.5'
gem 'json',    '~> 1.8.1'
gem 'rack-cors', '~> 0.2.9', require: 'rack/cors'

# Use Thin web server
gem 'thin', '~> 1.6.2'

# Use Sequel ORM tool
gem 'sequel',  '~> 4.13'
gem 'mysql2', '~> 0.3', '>= 0.3.16'
gem 'sinatra-sequel_extension', '~> 0.9.0', git: 'https://github.com/danascheider/sinatra-sequel_extension'
gem 'rake',    '~> 10.3.2'

# Use Sinatra-Backbone for the RestAPI module to prepare for integration
# with Backbone.js front-end
gem 'sinatra-backbone', '~> 0.1.1', :require => 'sinatra/backbone'

# Use ReactiveSupport to provide utility methods
gem 'reactive_support', '~> 0.2.2.beta2'

# Use Cucumber and RSpec for testing
# Coveralls and SimpleCov monitor test coverage
group :test do 
  gem 'simplecov',        '>= 0.8.2'
  gem 'coveralls',        '>= 0.7.0'
  gem 'json_spec',        '~> 1.1.2'
  gem 'cucumber-sinatra', '~> 0.5.0'
  gem 'cucumber',         '~> 1.3.16'
  gem 'rspec',            '~> 3.0'
  gem 'rack-test',        '~> 0.6.2', require: 'rack/test'
  gem 'factory_girl',     '~> 4.4'
  gem 'colorize',         '~> 0.7.3' # for Rake output
end

# Use require_all to clean up requires
gem 'require_all', '~> 1.3.2'
