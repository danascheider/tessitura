require          'sinatra'
require_relative 'routes'

class Canto < Sinatra::Application
  configure do 
    enable :sessions
  end
end