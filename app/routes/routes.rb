class Canto < Sinatra::Application 
  get '/' do 
    erb '/layouts/layout'.to_sym
  end

  rest_create '/tasks/?' do 
    Task.new
  end

  rest_resource '/tasks/:id/?' do |id|
    Task.find(id)
  end

  get '/tasks/new' do 
    @task = Task.new
    erb 'tasks/new'.to_sym
  end
end