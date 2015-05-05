# Run app using rackup -p 4567

require File.expand_path '../lib/canto.rb', __FILE__

use Rack::Reloader
run Canto