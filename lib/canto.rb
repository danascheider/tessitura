require 'sinatra/base'
require 'sequel'
require 'rack/cors'
require 'reactive_support/core_ext/object'
require 'reactive_extensions/object'
require 'reactive_extensions/hash'
require 'reactive_extensions/array'
require 'json'

require File.expand_path('../../config/settings', __FILE__)

Dir['./lib/models/*.rb'].each {|f| require f }

require File.expand_path '../routes/routing.rb', __FILE__
require File.expand_path '../routes/filters.rb', __FILE__
require File.expand_path '../routes/admin_routes.rb', __FILE__
require File.expand_path '../routes/listing_routes.rb', __FILE__
require File.expand_path '../routes/organization_routes.rb', __FILE__
require File.expand_path '../routes/program_routes.rb', __FILE__
require File.expand_path '../routes/season_routes.rb', __FILE__
require File.expand_path '../routes/task_routes.rb', __FILE__
require File.expand_path '../routes/user_routes.rb', __FILE__

class Canto < Sinatra::Base

  set :static, true

  register Sinatra::Canto::Routing::Filters
  register Sinatra::Canto::Routing::AdminRoutes
  register Sinatra::Canto::Routing::ListingRoutes
  register Sinatra::Canto::Routing::OrganizationRoutes
  register Sinatra::Canto::Routing::ProgramRoutes
  register Sinatra::Canto::Routing::SeasonRoutes
  register Sinatra::Canto::Routing::TaskRoutes
  register Sinatra::Canto::Routing::UserRoutes

  not_found do 
    [404, '' ]
  end

  post '/login' do
    login
  end
end
