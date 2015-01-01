require 'slogger'
require 'yaml'
Dir['./config/**/*.rb'].each {|f| require f }
Dir['./helpers/**/*'].each {|f| require f }

DB_YAML_FILE ||= File.expand_path('config/database.yml')
DB_CONFIG_INFO = DatabaseTaskHelper.get_yaml(DB_YAML_FILE)

class Canto < Sinatra::Base

  ENV['RACK_ENV'] ||= 'development'
  db_location = ENV['TRAVIS'] ? 'mysql2://travis@127.0.0.1:3306/test' : DatabaseTaskHelper.get_string(DB_CONFIG_INFO[ENV['RACK_ENV']], ENV['RACK_ENV'])

  set :root, File.dirname(__FILE__)
  set :app_file, __FILE__
  set :database,db_location
  set :data, ''

  # =======================================#
  # Rack::Cors manages cross-origin issues #
  # =======================================#

  use Rack::Cors do 
    allow do 
      origins 'null', /localhost(.*)/
      resource '/*', methods: [:get, :put, :post, :delete, :options], headers: :any
    end
  end

  # ===========================================#
  # Enable logging for database and web server #
  # ===========================================#

  enable :logging

  slogger = Slogger::Logger.new 'canto', :info, :local0
  use Slogger::Rack::RequestLogger, slogger

  db_loggers = [Logger.new(File.expand_path('../../log/db.log', __FILE__))]
  db_loggers << Logger.new(STDOUT) if ENV['LOG'] == true
  DB = Sequel.connect(database, loggers: db_loggers)

  # ================================== #
  # Sequel settings and modifications  #
  # ================================== #

  Sequel::Model.plugin :timestamps
  Sequel::Model.plugin :validation_helpers

  class Sequel::Dataset
    def to_json
      all.to_json
    end
  end

  helpers Sinatra::AuthorizationHelper 
  helpers Sinatra::ErrorHandling
  helpers Sinatra::GeneralHelperMethods
  helpers Sinatra::LogHelper
end