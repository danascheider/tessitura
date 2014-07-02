ENV['RACK_ENV'] = 'test'

support_path = File.expand_path('../../features/support', __FILE__)

require          'factory_girl'
require          'json_spec/helpers'
require          'rack/test'
require          'database_cleaner'
require_relative '../canto'
require_relative support_path + '/factories'
require_relative support_path + '/helpers'

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