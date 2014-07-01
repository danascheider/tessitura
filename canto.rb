require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  # begin_and_rescue method is defined in the ErrorHandling helper module

  get '/tasks' do 
    content_type :json
    params[:complete]? Task.find_by(complete: params[:complete]).to_json : Task.all.to_json
  end

  post '/tasks' do 
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) { Task.create!(JSON.parse request.body.read) && 201 }
  end

  get '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) { Task.find(id).to_json }
  end

  put '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) { Task.find(id).update!(JSON.parse request.body.read) }
  end

  delete '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) { Task.find(id).destroy }
  end
end