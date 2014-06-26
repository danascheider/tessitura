class Canto < Sinatra::Application 
  get '/' do 
    erb '/layouts/layout'.to_sym
  end

  get '/tasks/?' do 
    @tasks = Task.all
    erb 'tasks/index'.to_sym
  end

  get '/tasks/new' do 
    @task = Task.new
    erb 'tasks/new'.to_sym
  end
end