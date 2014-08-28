require_all File.expand_path('../../helpers',__FILE__)

class Canto < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :app_file, __FILE__
  set :database_file, 'config/database.yml'
  set :data, ''

  helpers Sinatra::AuthorizationHelper 
  helpers Sinatra::ErrorHandling
  helpers Sinatra::FilterUtils
  helpers Sinatra::GeneralHelperMethods
end