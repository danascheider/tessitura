require 'sinatra/base'
require 'sequel'
require 'rack/cors'
require 'rack/ssl'
require 'reactive_support/core_ext/object'
require 'reactive_extensions/object'
require 'reactive_extensions/hash'
require 'reactive_extensions/array'
require 'json'

require File.expand_path('../../config/settings', __FILE__)

require File.expand_path '../models/audition.rb', __FILE__
require File.expand_path '../models/listing.rb', __FILE__
require File.expand_path '../models/organization.rb', __FILE__
require File.expand_path '../models/program.rb', __FILE__
require File.expand_path '../models/season.rb', __FILE__
require File.expand_path '../models/task.rb', __FILE__
require File.expand_path '../models/task_list.rb', __FILE__
require File.expand_path '../models/user.rb', __FILE__

require File.expand_path '../routes/routing.rb', __FILE__
require File.expand_path '../routes/filters.rb', __FILE__
require File.expand_path '../routes/admin_routes.rb', __FILE__
require File.expand_path '../routes/listing_routes.rb', __FILE__
require File.expand_path '../routes/organization_routes.rb', __FILE__
require File.expand_path '../routes/program_routes.rb', __FILE__
require File.expand_path '../routes/season_routes.rb', __FILE__
require File.expand_path '../routes/task_routes.rb', __FILE__
require File.expand_path '../routes/user_routes.rb', __FILE__

class Tessitura < Sinatra::Base

  set :static, true
  use Rack::SSL

  register Sinatra::Tessitura::Routing::Filters
  register Sinatra::Tessitura::Routing::AdminRoutes
  register Sinatra::Tessitura::Routing::ListingRoutes
  register Sinatra::Tessitura::Routing::OrganizationRoutes
  register Sinatra::Tessitura::Routing::ProgramRoutes
  register Sinatra::Tessitura::Routing::SeasonRoutes
  register Sinatra::Tessitura::Routing::TaskRoutes
  register Sinatra::Tessitura::Routing::UserRoutes

  not_found do 
    [404, '' ]
  end

  post '/login' do
    login
  end
end
