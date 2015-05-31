# Run app using rackup -p 4567

require File.expand_path '../lib/tessitura.rb', __FILE__

use Rack::Reloader
run Tessitura