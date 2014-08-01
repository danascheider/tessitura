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

  protect 'General' do 
    get '/users/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless user.id == id.to_i || user.admin?
      [ 200, get_resource(User, id).to_json ]
    end
  end

  protect 'General' do 
    put '/users/:id' do |id|
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        user = User.find_by(username: auth.credentials.first)
        halt 401 unless user.id == id.to_i || user.admin?
        User.find(id).update!(@request_body)
        200
      end
    end
  end

  protect 'General' do 
    post '/users/:id/tasks' do |id|
      user = User.find_by(username: auth.credentials.first)
      # User should be able to specify a task list, but I'm saving that feature
      # for later to make sure they can't specify somebody else's task list and
      # get around security that way.
      halt 401 unless (user.id == id.to_i || user.admin?)
      @request_body[:task_list_id] = user.default_task_list.id

      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        Task.create!(@request_body)
        [ 201, @request_body ]
      end
    end
  end

  protect 'General' do
    get '/users/:id/tasks' do |id|
      # FIX: This will need a more robust error-handling approach - TBD
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, User.find(id).tasks.to_json ]
      end
    end
  end

  protect 'General' do
    get '/tasks/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless get_resource(Task, id).user.id == user.id || user.admin?
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, get_resource(Task, id).to_json ]
      end
    end
  end

  protect 'General' do 
    put '/tasks/:id' do |id|
      user = User.find_by(username: auth.credentials.first)
      halt 401 unless get_resource(Task, id).user.id == user.id || user.admin?
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        Task.find(id).update!(@request_body)
      end
    end
  end

  protect 'General' do 
    delete '/tasks/:id' do |id|
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        user = User.find_by(username: auth.credentials.first)
        halt 401 unless Task.find(id).user.id == user.id || user.admin?
        Task.find(id).destroy!
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
    get '/users' do 
      [ 200, User.all.to_json ]
    end
  end
end