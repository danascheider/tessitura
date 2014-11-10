require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start if ENV["COVERAGE"]

ENV['RACK_ENV'] = 'test'
DB_PASSWD = 'hunter2'
DB_PATH = ENV['TRAVIS'] ? "mysql2://travis@127.0.0.1:3306/test" : "mysql2://canto:#{DB_PASSWD}@127.0.0.1:3306/#{ENV['RACK_ENV']}"

db_info = {host: '127.0.0.1', port: 3306}

if ENV['TRAVIS']
  db_info[:username], db_info[:database] = 'travis', 'test'
else
  db_info[:username], db_info[:password], db_info[:database] = 'canto', DB_PASSWD, ENV['RACK_ENV']
end

support_path = File.expand_path('../../features/support', __FILE__)
app_path = File.expand_path('../..', __FILE__)

require          'factory_girl'
require          'json_spec/helpers'
require          'rack/test'
require          'mysql2'
require          'rspec/core/rake_task'
require          'colorize'
require_relative '../canto'
require_relative support_path + '/factories'
require_relative support_path + '/helpers'

Dir["./spec/support/**/*.rb"].sort.each {|f| require f }

RSpec.configure do |config|
  config.include JsonSpec::Helpers
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.order = 'random'

  DB = Sequel.connect(DB_PATH)

  config.before(:each) do 
    if ENV['TRAVIS']
      system 'rake travis:prepare'
    else
      system 'rake db:test:prepare > /dev/null 2>&1'
    end
  end
end

def app
  Canto
end
