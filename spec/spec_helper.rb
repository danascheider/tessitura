require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start if ENV["COVERAGE"]

ENV['RACK_ENV'] = 'test'

support_path = File.expand_path('../../features/support', __FILE__)

require          'factory_girl'
require          'rack/test'
require          'mysql2'
require          'rspec/core/rake_task'
require          'colorize'
require_relative '../lib/tessitura'
require_relative support_path + '/factories'
require_relative support_path + '/helpers'

Dir["./spec/support/**/*.rb"].each {|f| require f }

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.order = 'random'

  DB = Sequel::DATABASES.first

  config.before(:suite) do
    if ENV['TRAVIS']
      system 'rake travis:prepare' 
    else
      system 'rake db:test:prepare'
    end
  end

  config.around(:each) do |example|
    DB.transaction(rollback: :always) do 
      example.run 
    end
  end
end

def app
  Tessitura
end
