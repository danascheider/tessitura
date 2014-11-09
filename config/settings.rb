require 'logger'
require_all File.expand_path('../../helpers',__FILE__)

class Canto < Sinatra::Base
  ENVIRONMENT = ENV['RACK_ENV'] || 'development'
  DB_PASSWORD = 'hunter2'

  set :root, File.dirname(__FILE__)
  set :app_file, __FILE__
  set :database, database_string
  set :data, ''

  # Rack::Cors manages cross-origin issues
  # ======================================

  use Rack::Cors do 
    allow do 
      origins 'null', /localhost(.*)/
      resource '/*', methods: [:get, :put, :post, :delete, :options], headers: :any
    end
  end

  # Enable logging for database and web server
  # ==========================================

  enable :logging

  file = File.new(File.expand_path("../../log/canto.log", __FILE__), 'a+')
  file.sync = true
  use Rack::CommonLogger, file

  db_loggers = [Logger.new(File.expand_path('../../log/db.log', __FILE__))]
  db_loggers << Logger.new(STDOUT) if ENV['LOG'] == true
  DB = Sequel.connect(database, loggers: db_loggers)

  # Sequel settings and modifications
  # =================================

  Sequel::Model.plugin :timestamps
  Sequel::Model.plugin :validation_helpers

  class Sequel::Dataset
    def to_json
      all.to_json
    end
  end

  # Canto-specific helper modules
  # =============================

  helpers Sinatra::AuthorizationHelper 
  helpers Sinatra::ErrorHandling
  helpers Sinatra::GeneralHelperMethods
  helpers Sinatra::LogHelper
  helpers Sinatra::CIHelper
end