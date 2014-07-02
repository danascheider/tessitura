ENV['RACK_ENV'] = 'test'

require          'factory_girl'
require          'json_spec/helpers'
require          'rack/test'
require          'database_cleaner'
require_relative '../canto'
require_relative '../features/support/helpers'
require_all      File.dirname(__FILE__) + '/factories'

RSpec.configure do |config|
  config.include JsonSpec::Helpers
  config.include Rack::Test::Methods

  config.before(:suite) do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do 
      example.run
    end
  end

end

def app
  Canto
end