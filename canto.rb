require          'sinatra'
require          'sinatra/jstpages'
require          'sinatra/assetpack'
require          'sinatra/restapi'
require          'sinatra/activerecord'
require          'sinatra/asset_pipeline'
require          'sqlite3'
require          'sinatra/backbone'
require          'require_all'
require_all 'app'

class Canto < Sinatra::Application
  set :root, File.expand_path('../app', __FILE__)
  set :database_file, '../config/database.yml'

  register Sinatra::ActiveRecordExtension
  register Sinatra::AssetPack
  register Sinatra::JstPages
  register Sinatra::AssetPipeline

  # RestAPI can create RESTful resources using rest_resource and
  # rest_create methods. An example could be:
  #
  # => rest_resource '/book/:id' do |id|
  # =>   Book.find(:id => id)
  # => end
  register Sinatra::RestAPI

  serve_jst 'assets/javascripts/jst.js'

  assets {
    serve '/js', from: 'assets/javascripts'
    serve '/css', from: 'assets/stylesheets'
    serve '/images', from: 'assets/images'

    js :application, '/js/application.js', ['js/application.min.js']

    css :application, 'css/application.css', ['css/application.min.css']

    js_compression :jsmin
    css_compression :simple
  }

  configure do 
    enable :sessions
  end
end