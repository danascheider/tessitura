require 'require_all'
require 'sinatra/base'
require 'sinatra/sequel'
require 'sequel'
require 'reactive_support'
require 'reactive_support/core_ext/object/blank'
require 'reactive_support/core_ext/object/inclusion'
require 'reactive_support/core_ext/object/try'
require 'reactive_support/extensions/reactive_extensions'
require 'json'
require File.expand_path('../config/settings', __FILE__)

Dir['./models/**/*'].each {|f| require f }
Dir['../helpers/**/*'].each {|f| require f }

class Canto < Sinatra::Base

  not_found do 
    [404, '' ]
  end

  before do
    request.body.rewind # best practices
    @request_body = parse_json(request.body.read)
    @id = request.path_info.match(/\d+/).to_s
  end

  before /\/users\/(\d+)(\/*)?/ do 
    protect(User)
  end

  before /\/tasks\/(\d+)(\/*)?/ do 
    protect(Task)
  end

  before /\/admin\/*/ do 
    admin_only!
  end

  # The following paths are included for debugging purposes only:

  # get '/' do 
  #   "Hello Canto!\n"
  # end

  # post '/' do 
  #   "Hello Canto!\nYou posted #{@request_body}!\n"
  # end
  
  post '/users' do  
    validate_standard_create
    User.create(@request_body) && 201 rescue 422
  end

  [ '/users/:id', '/tasks/:id' ].each do |route, id|
    get route do 
      @resource && @resource.to_json || 404
    end

    put route do 
      return 404 unless @resource
      @resource.update(@request_body) && 200 rescue 422
    end

    delete route do 
      destroy_resource(@resource)
    end
  end

  post '/users/:id/tasks' do |id|
    @request_body[:task_list_id] ||= User[id].default_task_list.id
    create_resource(Task, @request_body)
  end

  get '/users/:id/tasks' do |id|
    return_json(@resource.tasks)
  end

  # Admin-Only Routes
  # =================

  post '/admin/users' do 
    create_resource(User, @request_body)
  end

  get '/admin/users' do 
    return_json(User.all)
  end
end