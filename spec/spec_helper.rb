require          'factory_girl'
require          'json_spec/helpers'
require          'rack/test'
require_relative '../canto'
require_all      File.dirname(__FILE__) + '/factories'

RSpec.configure do |config|
  config.include JsonSpec::Helpers
end