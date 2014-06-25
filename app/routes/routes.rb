class Canto < Sinatra::Application 
  get '/' do 
    erb '/layouts/layout'.to_sym
  end

  get '/tasks/?' do 
    erb :tasks
  end
end