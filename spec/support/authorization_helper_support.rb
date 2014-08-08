class Canto < Sinatra::Application
  get '/test/access_denied' do 
    access_denied
    { 'message' => 'Hello world' }.to_json
  end

  post '/test/setting_admin' do 
    [ setting_admin? ].to_json
  end

  get '/test/users/id' do 
    @id = id
    protect(User)
    { 'message' => 'Hello world' }.to_json
  end
end