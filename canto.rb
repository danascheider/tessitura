require 'sinatra'

class Canto < Sinatra::Application
  configure do 
    enable :sessions
  end
end