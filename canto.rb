require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/basic_auth'
require 'acts_as_list'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'
require_all 'controllers'

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
      User.create!(@request_body)
      201
    end
  end

  get '/users' do 
    405
  end

  protect 'General' do 
    get '/users/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless user.id == id.to_i || user.admin?
      [ 200, get_resource(User, id) {|profile| profile.to_json } ]
    end
  end

  protect 'General' do 
    put '/users/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless user.admin? || (user.id == id.to_i && !@request_body['admin'])
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        get_resource(User, id) {|user| user.update!(@request_body) }
      end
    end
  end

  protect 'General' do 
    delete '/users/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless user.id == id.to_i || user.admin?
      begin_and_rescue(ActiveRecord::RecordNotDestroyed, 403) do
        get_resource(User, id) { |user| user.destroy! } ? 204 : 404
      end
    end
  end

  protect 'General' do 
    post '/users/:id/tasks' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless (user.id == id.to_i || user.admin?)
      @request_body[:task_list_id] = User.find(id).default_task_list.id
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        Task.create!(@request_body)
        [ 201, { body: @request_body }]
      end
    end
  end

  protect 'General' do
    get '/users/:id/tasks' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless (user.id == id.to_i || user.admin?)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, get_resource(User, id) {|user| user.tasks.to_json } ]
      end
    end
  end

  protect 'General' do
    get '/tasks/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      return 404 unless (@task = get_resource(Task, id))
      halt 401 unless @task.user.id == user.id || user.admin?
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, @task.to_json ]
      end
    end
  end

  protect 'General' do 
    put '/tasks/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      return 404 unless (@task = get_resource(Task, id))
      halt 401 unless (get_resource(Task, id).user.id == user.id || user.admin?)
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        get_resource(Task, id) {|task| task.update!(@request_body) }
      end
    end
  end

  protect 'General' do 
    delete '/tasks/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        halt 401 unless Task.find(id).user.id == user.id || user.admin?
        get_resource(Task, id) {|task| task.destroy! }
        204
      end
    end
  end

  protect 'Admin' do 
    post '/admin/users' do 
      User.create!(@request_body)
      201
    end
  end

  protect 'Admin' do 
    get '/admin/users' do 
      [ 200, User.all.to_json ]
    end
  end
end