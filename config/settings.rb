require 'logger'
require_all File.expand_path('../../helpers',__FILE__)

class Canto < Sinatra::Base
  ENVIRONMENT = ENV['RACK_ENV'] || 'development'
  ROOT_PASSWORD = 'vagrant'

  set :root, File.dirname(__FILE__)
  set :app_file, __FILE__
  set :database, "mysql2://root:#{ROOT_PASSWORD}@127.0.0.1:3306/#{ENVIRONMENT}"
  set :data, ''

  enable :logging

  file = File.new(File.expand_path("../../log/canto.log", __FILE__), 'a+')
  file.sync = true
  use Rack::CommonLogger, file

  db_loggers = [Logger.new(File.expand_path('../../log/db.log', __FILE__)), Logger.new(STDOUT)]
  DB = Sequel.connect(database, loggers: db_loggers)

  Sequel::Model.plugin :timestamps
  Sequel::Model.plugin :validation_helpers

  helpers Sinatra::AuthorizationHelper 
  helpers Sinatra::ErrorHandling
  helpers Sinatra::FilterUtils
  helpers Sinatra::GeneralHelperMethods
end