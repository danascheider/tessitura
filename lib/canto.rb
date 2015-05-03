require 'sinatra/base'
require 'sequel'
require 'rack/cors'
require 'reactive_support/core_ext/object'
require 'reactive_extensions/object'
require 'reactive_extensions/hash'
require 'reactive_extensions/array'
require 'json'
require File.expand_path('../../config/settings', __FILE__)

require_relative './routes/routing.rb'
require_relative './routes/filters.rb'
require_relative './routes/admin_routes.rb'
require_relative './routes/listing_routes.rb'

Dir['./lib/models/*.rb'].each {|f| require f }
Dir['./lib/routes/*.rb'].each {|f| require f }

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