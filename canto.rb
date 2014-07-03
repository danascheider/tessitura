require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'
require_all 'controllers'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  get '/tasks' do 
    content_type :json
    params[:complete] ? find_by(:complete, params[:complete]).to_json : Task.all.to_json
  end

  post '/tasks' do 
    create_task(request_body)
  end

  get '/tasks/:id' do |id|
    get_task(id)
  end

  put '/tasks/:id' do |id|
    update_task(id, request_body)
  end

  delete '/tasks/:id' do |id|
    delete_task(id)
  end
end