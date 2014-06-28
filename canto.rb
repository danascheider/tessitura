require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'require_all'
require_all 'models'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
end