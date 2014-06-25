class Canto < Sinatra::Application 
  get '/' do 
    erb '/layouts/layout'.to_sym
  end
end