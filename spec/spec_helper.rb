require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start if ENV["COVERAGE"]

ENV['RACK_ENV'] = 'test'
DB_PASSWD = 'vagrant'

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

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
  config.include JsonSpec::Helpers
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.order = 'random'

  DB = Sequel.connect("mysql2://root:#{DB_PASSWD}@127.0.0.1:3306/#{ENV['RACK_ENV']}")
  CLIENT = Mysql2::Client.new(host: '127.0.0.1', username: 'root', password: 'vagrant', port: 3306, database: ENV['RACK_ENV'])
  Sequel::Model.db = DB

  config.before(:each) do
    system 'rake db:test:prepare > /dev/null 2>&1'
  end
end

def app
  Canto
end
