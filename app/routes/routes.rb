class Canto < Sinatra::Application 
  get '/' do 
    erb '/layouts/layout'.to_sym
  end

  get '/tasks/?' do 
    erb 'tasks/index'.to_sym
  end

  get '/tasks/new' do 
    erb 'tasks/new'.to_sym
  end
end