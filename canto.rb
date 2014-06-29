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
    Task.all.to_json
  end

  get '/tasks/:id' do |id|
    Task.find(id).to_json
  end
end