require 'sinatra'
require 'sinatra/activerecord'
require 'acts_as_list'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  before do
    @request_body = parse_json(request.body.read)
    @id = request.path_info.match(/\d+/).to_s
  end

  before /\/users\/(\d+)(\/*)?/ do 
    protect(User)
  end

  get '/' do 
    "Welcome to Canto\n"
  end

  post '/users' do  
    halt 401 if @request_body.has_key? "admin"
    create_resource(User, @request_body)
  end

  get '/users' do 
    405
  end

  get '/users/:id' do |id|
    return_json(@resource) || 404
  end

  put '/users/:id' do |id|
    update_resource(@request_body, @resource)
  end

  delete '/users/:id' do |id|
    destroy_resource(@resource)
  end

  post '/users/:id/tasks' do |id|
    @request_body[:task_list_id] ||= @resource.default_task_list.id
    create_resource(Task, @request_body)
  end

  get '/users/:id/tasks' do |id|
    return_json(@resource.tasks)
  end

  get '/tasks/:id' do |id|
    protect(Task)
    return_json(@resource) || 404
  end

  put '/tasks/:id' do |id|
    protect(Task)
    update_resource(@request_body, @resource)
  end

  delete '/tasks/:id' do |id|
    protect(Task)
    destroy_resource(@resource)
  end

  # Admin-Only Routes
  # =================

  post '/admin/users' do 
    admin_only!
    create_resource(User, @request_body)
  end

  get '/admin/users' do 
    admin_only!
    return_json(User.all)
  end
end