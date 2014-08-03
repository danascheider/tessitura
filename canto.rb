require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/basic_auth'
require 'acts_as_list'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  authorize 'General' do |username, password|
    password == User.find_by(username: username).password
  end

  authorize 'Admin' do |username, password|
    @user = User.find_by(username: username)
    password == @user.password && @user.admin?
  end

  before do 
    @request_body = parse_json(request.body.read)
  end

  get '/' do 
    "Welcome to Canto\n"
  end

  post '/users' do 
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      halt 401 if @request_body.has_key? "admin"
      create_resource(User, @request_body)
    end
  end

  get '/users' do 
    405
  end

  protect 'General' do 
    get '/users/:id' do |id|
      user_route_boilerplate(id)
      @user ? @user.to_json : 404
    end
  end

  protect 'General' do 
    put '/users/:id' do |id|
      user_route_boilerplate(id)
      update_resource(@request_body, @user)
    end
  end

  protect 'General' do 
    delete '/users/:id' do |id|
      user_route_boilerplate(id)
      begin_and_rescue(ActiveRecord::RecordNotDestroyed, 403) do
       @user && @user.destroy! ? 204 : 404
      end
    end
  end

  protect 'General' do 
    post '/users/:id/tasks' do |id|
      user_route_boilerplate(id)
      @request_body[:task_list_id] = User.find(id).default_task_list.id
      create_resource(Task, @request_body)
    end
  end

  protect 'General' do
    get '/users/:id/tasks' do |id|
      user_route_boilerplate(id)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, get_resource(User, id) {|user| user.tasks.to_json } ]
      end
    end
  end

  protect 'General' do
    get '/tasks/:id' do |id|
      task_route_boilerplate(id)
      @task ? @task.to_json : 404
    end
  end

  protect 'General' do 
    put '/tasks/:id' do |id|
      task_route_boilerplate(id)
      update_resource(@request_body, @task)
    end
  end

  protect 'General' do 
    delete '/tasks/:id' do |id|
      task_route_boilerplate(id)
      @task ? @task.destroy! && 204 : 404
    end
  end

  protect 'Admin' do 
    post '/admin/users' do 
      create_resource(User, @request_body)
    end
  end

  protect 'Admin' do 
    get '/admin/users' do 
      User.all.to_json
    end
  end
end