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
    protected!
    user_route_boilerplate(id)
    return_json(@user) || 404
  end

  put '/users/:id' do |id|
    protected!
    user_route_boilerplate(id)
    update_resource(@request_body, @user)
  end

  delete '/users/:id' do |id|
    protected!
    user_route_boilerplate(id)
    destroy_resource(@user)
  end

  post '/users/:id/tasks' do |id|
    protected!
    user_route_boilerplate(id)
    @request_body[:task_list_id] = @user.default_task_list.id
    create_resource(Task, @request_body)
  end

  get '/users/:id/tasks' do |id|
    protected!
    user_route_boilerplate(id)
    return_json(@user.tasks) || 404
  end

  get '/tasks/:id' do |id|
    protected!
    task_route_boilerplate(id)
    return_json(@task) || 404
  end

  put '/tasks/:id' do |id|
    protected!
    task_route_boilerplate(id)
    update_resource(@request_body, @task)
  end

  delete '/tasks/:id' do |id|
    protected!
    task_route_boilerplate(id)
    destroy_resource(@task)
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