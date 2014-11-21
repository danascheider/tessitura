class Canto < Sinatra::Base
  before /\/test\/(.*)/ do
    # FIX: It is possible that this filter is the reason for the problems
    #      I'm having elsewhere with instance variables set in filters
    #      not being available
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

  put '/test/users/:id/tasks' do 
    protect_collection(request_body)
    { 'message' => 'Successful' }.to_json
  end

  post '/test/request-body' do 
    request_body.class.to_s
  end
end