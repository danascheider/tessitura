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
    @user = User.find_by(username: username)
    password == @user.password
  end

  authorize 'Admin' do |username, password|
    @user = User.find_by(username: username)
    password == @user.password && @user.admin?
  end

  before do 
    @request_body = parse_json(request.body.read)
  end

  get '/' do 
    204
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
      @user = get_resource(User, id) ? [ 200, @user.to_json ] : 404
    end

    put '/users/:id' do |id|
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
        [ 200, User.find(id).update!(@request_body) ]
      end
    end

    get '/users/:id/tasks' do |id|
      # FIX: This will need a more robust error-handling approach - TBD
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, User.find(id).tasks.to_json ]
      end
    end

    get '/tasks/:id' do |id|
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
        [ 200, get_task(id) ]
      end
    end

    put '/tasks/:id' do |id|
      begin_and_rescue(ActiveRecord::RecordInvalid, 422) { update_task(id, @request_body); 200 }
    end

    delete '/tasks/:id' do |id|
      begin_and_rescue(ActiveRecord::RecordNotFound, 404) { delete_task(id); 204 }
    end
  end

  protect 'Admin' do 
    post '/admin/users' do 
      User.create!(@request_body)
      201
    end

    get '/admin/users' do 
      [ 200, User.all.to_json ]
    end
  end
end