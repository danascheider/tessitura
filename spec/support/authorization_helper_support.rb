class Canto < Sinatra::Base
  get '/test/access_denied' do 
    access_denied
    { 'message' => 'Hello world' }.to_json
  end

  get '/test/users/id' do 
    protect(User)
    { 'message' => 'Hello world' }.to_json
  end
end