require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start if ENV["COVERAGE"]

ENV['RACK_ENV'] = 'test'

support_path = File.expand_path('../../features/support', __FILE__)
app_path = File.expand_path('../..', __FILE__)

require          'factory_girl'
require          'json_spec/helpers'
require          'rack/test'
require          'database_cleaner'
require_relative '../canto'
require_relative support_path + '/factories'
require_relative support_path + '/helpers'

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}


RSpec.configure do |config|
  config.include JsonSpec::Helpers
  config.include Rack::Test::Methods

  db_path = File.expand_path("../..#{Canto::database}", __FILE__)
  connection = Sequel.connect("sqlite:/#{db_path}")
  cleaner = DatabaseCleaner[:sequel, {connection: connection}]

  config.before(:suite) do 
    DatabaseCleaner.strategy = :truncation
  end

  config.around(:each) do |example|
    DatabaseCleaner.start 
    example.run
    DatabaseCleaner.clean
  end

end

def app
  Canto
end
