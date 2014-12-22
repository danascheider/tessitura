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

class Canto < Sinatra::Base

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

  ###################

  before /^\/users\/(\d+)\/tasks/ do 
    request.put? ? protect_collection(request_body) : protect(User)
  end

  before /^\/users\/(\d+)(\/*)?/ do 
    protect(User)
  end

  before /^\/tasks\/(\d+)(\/*)?/ do 
    protect(Task)
  end

  before /\/admin\/*/ do 
    admin_only!
  end

  ##### End Filters #####

  post '/users' do  
    access_denied if setting_admin?
    return 422 unless new_user = User.try_rescue(:create, request_body)
    [201, new_user.to_json]
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

  post '/users/:id/tasks' do |id|
    (body = request_body)[:task_list_id] ||= User[id].default_task_list.id
    return 422 unless new_task = Task.try_rescue(:create, body)

    [201, new_task.to_json]
  end

  put '/users/:id/tasks' do |id|
    tasks = (body = request_body).map {|h| Task[h.delete(:id)] } 

    body.each do |hash| 
      (task = tasks[body.index(hash)]).set(sanitize_attributes(hash))
      return 422 unless task.valid? && task.owner_id === id.to_i
    end
    
    tasks.each {|task| task.save } && 200
  end

  get '/users/:id/tasks' do |id|
    return_json(@resource.tasks.where_not(:status, 'Complete')) || [].to_json
  end

  get '/users/:id/tasks/all' do |id|
    return_json(@resource.tasks)
  end

  post '/listings' do 
    return 422 unless listing = Listing.try_rescue(:create, request_body)
    [201, listing.to_json]
  end

  post '/login' do
    login
  end

  # Admin-Only Routes
  # =================

  post '/admin/users' do 
    return 422 unless u = User.try_rescue(:create, request_body)
    [201, u.to_json]
  end

  get '/admin/users' do 
    return_json(User.all)
  end
end