require_all File.expand_path('../../helpers',__FILE__)

class Canto < Sinatra::Base
  ENVIRONMENT = ENV['RACK_ENV'] || 'development'

  set :root, File.dirname(__FILE__)
  set :app_file, __FILE__
  set :database_file, 'config/database.yml'
  set :database, "/db/#{ENVIRONMENT}.sqlite3"
  set :data, ''

  Sequel::Model.db = database
  DB = Sequel.sqlite("sqlite:/#{database}")

  helpers Sinatra::AuthorizationHelper 
  helpers Sinatra::ErrorHandling
  helpers Sinatra::FilterUtils
  helpers Sinatra::GeneralHelperMethods
end