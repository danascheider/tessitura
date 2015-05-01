require 'sinatra/base'
require 'sequel'
require 'rack/cors'
require 'reactive_support/core_ext/object'
require 'reactive_extensions/object'
require 'reactive_extensions/hash'
require 'reactive_extensions/array'
require 'json'
require File.expand_path('../../config/settings', __FILE__)

require_relative 'models/user.rb'
Dir['models/**/*.rb'].each {|f| require f }
Dir['helpers/**/*'].each {|f| require f }
Dir['./routes/**/*'].each {|f| require f }

class Canto < Sinatra::Base

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