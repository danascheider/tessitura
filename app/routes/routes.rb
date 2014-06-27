class Canto < Sinatra::Application 
  register Sinatra::RestAPI

  get '/' do 
    erb '/layouts/layout'.to_sym
  end

  rest_create '/tasks/?' do 
    Task.new
  end

  rest_get '/tasks/?' do
    @tasks = Task.all
  end

  rest_resource '/tasks/:id/?' do |id|
    Task.find(id)
  end
end