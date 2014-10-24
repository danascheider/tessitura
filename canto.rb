require 'require_all'
require 'sinatra/base'
require 'sinatra/sequel'
require 'sequel'
require 'rack/cors'
require 'reactive_support'
require 'reactive_support/core_ext/object/blank'
require 'reactive_support/core_ext/object/inclusion'
require 'reactive_support/core_ext/object/try'
require 'reactive_support/extensions/reactive_extensions'
require 'json'
require File.expand_path('../config/settings', __FILE__)

Dir['./models/**'].each {|f| require f }
Dir['../helpers/**/*'].each {|f| require f }

class Canto < Sinatra::Base

  not_found do 
    [404, '' ]
  end

  before do
    File.open('./log/canto.log', 'a+') do |file| 
      file.puts "\n"
      request.env.each {|key, value| file.puts("#{key.upcase}: #{value}")}
    end

    @id = request.path_info.match(/\d+/).to_s
  end

  before /\/users\/(\d+)(\/*)?/ do 
    request.body.rewind
    @request_body = parse_json(request.body.read)
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
    request.body.rewind; @request_body = parse_json(request.body.read)
    validate_standard_create
    User.create(@request_body) && 201 rescue 422
  end

  [ '/users/:id', '/tasks/:id' ].each do |route, id|
    get route do 
      headers('Content-Type' => 'application/json')
      @resource && @resource.to_json || 404
    end

    put route do 
      request.body.rewind; @request_body = parse_json(request.body.read)
      return 404 unless @resource
      @resource.update(@request_body) && 200 rescue 422
    end

    delete route do 
      destroy_resource(@resource)
    end
  end

  post '/users/:id/tasks' do |id|
    request.body.rewind; @request_body = parse_json(request.body.read)
    @request_body[:task_list_id] ||= User[id].default_task_list.id
    create_resource(Task, @request_body)
  end

  get '/users/:id/tasks' do |id|
    return_json(@resource.tasks)
  end

  post '/login' do
    login
  end

  # Admin-Only Routes
  # =================

  post '/admin/users' do 
    request.body.rewind; @request_body = parse_json(request.body.read)
    User.create(@request_body) && 201 rescue 422
  end

  get '/admin/users' do 
    return_json(User.all)
  end
end