# Run app using rackup -p 4567

require './lib/canto'

use Rack::Reloader
run Canto