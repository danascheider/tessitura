require 'sinatra'
require 'sinatra/activerecord'
require 'acts_as_list'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'
require_all 'controllers'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  use Rack::Auth::Basic, 'Restricted Area' do |username, password|
    if /^\/users\/(\d+)/ =~ request.path
      @user_id = params[:id]
    elsif /^\/tasks\/(\d+)/ =~ request.path 
      @user_id = Task.find(id).user.id 
    end

    return false unless @user = User.find_by(username: username)
    (password == @user.password && @user_id == @user.id) || @user.admin?
  end

  before do 
    begin
      @request_body = JSON.parse request.body.read 
    rescue(JSON::ParserError)
      @request_body = nil
    end
  end

  get '/' do 
    204
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

  # USER ROUTES
  # ===========

  post '/users' do 
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      User.create!(@request_body)
      [ 201, { 'secret_key' => User.last.secret_key }.to_json ]
    end
  end

  get '/users' do 
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
      content_type :json
      [ 200, User.all.to_json ]
    end
  end

  get '/users/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
      [ 200, User.find(id).to_json ]
    end
  end

  put '/users/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      [ 200, User.find(id).update!(@request_body) ]
    end
  end
end