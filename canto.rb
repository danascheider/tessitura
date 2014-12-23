require 'sinatra/base'
require 'sequel'
require 'rack/cors'
require 'reactive_support/core_ext/object'
require 'reactive_extensions/object'
require 'reactive_extensions/hash'
require 'reactive_extensions/array'
require 'json'

require File.expand_path('../config/settings', __FILE__)

Dir['./models/**'].each {|f| require f }
Dir['../helpers/**/*'].each {|f| require f }
Dir['./routes/**/*'].each {|f| require f }

class Canto < Sinatra::Base

  register Sinatra::Canto::Routing::UserRoutes
  register Sinatra::Canto::Routing::TaskRoutes
  register Sinatra::Canto::Routing::AdminRoutes
  register Sinatra::Canto::Routing::ListingRoutes
  register Sinatra::Canto::Routing::OrganizationRoutes
  register Sinatra::Canto::Routing::ProgramRoutes

  not_found do 
    [404, '' ]
  end

  ##### Logging #####

  before do
    @id = request.path_info.match(/\d+/).to_s
    log_request
  end

  after do 
    log_response
  end

  # ------- #
  # Filters #
  # ------- #

  before /^\/users\/(\d+)\/tasks/ do 
    request.put? ? protect_collection(request_body) : protect(User)
  end

  before /^\/users\/(\d+)(\/*)?/ do 
    protect(User)
  end

  before /^\/tasks\/(\d+)(\/*)?/ do 
    protect(Task)
  end

  before /\/organizations\/*/ do 
    request.get? ? protect_communal : admin_only!
  end

  before /\/programs\/*/ do 
    request.get? ? protect_communal : admin_only!
  end

  before /\/admin\/*/ do 
    admin_only!
  end

  # ------ #
  # Routes #
  # ------ #

  post '/login' do
    login
  end

  [ '/users/:id', '/tasks/:id' ].each do |route, id|
    get route do 
      @resource && @resource.to_json || 404
    end

    put route do 
      update_resource(request_body, @resource)
    end

    delete route do 
      return 404 unless @resource
      @resource.try_rescue(:destroy) && 204 || 403
    end
  end
end