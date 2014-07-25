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

  before do 
    validate_params(params)
  end

  get '/tasks' do 
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
      content_type :json
      if params[:complete]
        to_bool(params[:complete]) ? Task.complete.to_json : Task.incomplete.to_json
      else
        Task.all.to_json
      end
    end
  end

  post '/tasks' do 
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) { create_task(request_body); 201 }
  end

  get '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) { get_task(id) }
  end

  put '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) { update_task(id, request_body); 200 }
  end

  delete '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) { delete_task(id); 204 }
  end

  # USER ROUTES
  # ===========

  post '/users' do 
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      if validate_and_create_user(request_body)
        return body({ 'secret_key' => User.last.secret_key }.to_json) && 201
      end
      401
    end
  end

  put '/users/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      if validate_and_update_user(id, request_body)
        return status(200)
      end
      401
    end
  end
end