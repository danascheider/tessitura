require 'slogger'
require 'yaml'
require 'reactive_support/core_ext/hash'
Dir['./config/**/*.rb'].each {|f| require f }
Dir['./lib/*.rb'].each {|f| require f }
Dir['./lib/helpers/**/*.rb'].each {|f| require f }

DB_YAML_FILE = ENV['DB_YAML_FILE'] || File.expand_path('config/database.yml')
CONFIG_FILE = ENV['CONFIG_FILE'] || File.expand_path('config/config.yml')

DB_CONFIG_INFO = DatabaseTaskHelper.get_yaml(DB_YAML_FILE)
CONFIG_INFO = (File.open(CONFIG_FILE, 'r+') {|file| YAML.load(file) }).symbolize_keys!

class Canto < Sinatra::Base

  ENV['RACK_ENV'] = 'defaults'
  db_location = ENV['TRAVIS'] ? 'mysql2://travis@127.0.0.1:3306/test' : DatabaseTaskHelper.get_string(DB_CONFIG_INFO[ENV['RACK_ENV']], ENV['RACK_ENV'])

  set :app_file, File.expand_path(CONFIG_INFO[:app_file])
  set :root, File.dirname(app_file)
  set :database, db_location
  set :data, CONFIG_INFO[:data] || ''

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

  db_loggers = CONFIG_INFO[:db_loggers].map {|filename| Logger.new(File.expand_path(filename)) }
  db_loggers << Logger.new(STDOUT) if ENV['LOG'] === true
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
