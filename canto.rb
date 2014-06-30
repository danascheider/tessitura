require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'require_all'
require_all 'models'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  get '/tasks' do 
    content_type :json
    params[:complete]? Task.find_by(complete: params[:complete]).to_json : Task.all.to_json
  end

  post '/tasks' do 
    begin
      Task.create!(JSON.parse request.body.read) && 201
    rescue ActiveRecord::RecordInvalid
      422
    end
  end

  get '/tasks/:id' do |id|
    begin
      Task.find(id).to_json
    rescue ActiveRecord::RecordNotFound
      404
    end
  end
end