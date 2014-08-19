shared_examples 'an authorized POST request to /filters' do 
  before(:each) do 
    authorize_with agent
    make_request('POST', '/filters', { 'user' => @list.user.id, 'resource' => 'tasks', 'filters' => { 'status' => 'complete' }}.to_json)
  end

  it 'returns the requested tasks in JSON format' do 
    expect(response_body).to eql expected.to_json
  end

  it 'returns status 200' do 
    expect(response_status).to eql 200
  end
end

shared_examples 'an unauthorized POST request to /filters' do 
  before(:each) do 
    authenticate
    make_request('POST', '/filters', { 'user' => user_id, 'resource' => 'tasks', 'filters' => {'status' => 'complete'}}.to_json)
  end

  it 'doesn\'t return the requested tasks' do 
    expect(response_body).to eql "Authorization Required\n"
  end

  it 'returns status 401' do 
    expect(response_status).to eql 401
  end
end