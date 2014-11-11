class Canto < Sinatra::Base
  before do
    @request_body = parse_json(request.body.read)
    @id = request.path_info.match(/\d+/).to_s
  end

  get '/test/access_denied' do 
    access_denied
    { 'message' => 'Hello world' }.to_json
  end

  get '/test/users/:id' do 
    protect(User)
    { 'message' => 'Hello world' }.to_json
  end
end