shared_examples 'an authorized GET request' do 
  before(:each) do 
    authorize_with agent
    make_request('GET', path)
  end

  it 'returns the requested resource' do 
    expect(response_body).to eql resource
  end

  it 'returns status 200' do 
    expect(response_status).to eql 200
  end
end

shared_examples 'an unauthorized GET request' do 
  before(:each) do 
    authorize username, password if username && password
    make_request('GET', path)
  end

  it 'doesn\'t return the requested resource' do 
    expect(response_body).not_to include resource
  end

  it 'returns status 401' do 
    expect(response_status).to eql 401
  end
end

shared_examples 'a GET request without credentials' do 
  before(:each) do 
    make_request('GET', path) 
  end

  it 'doesn\'t return the requested resource' do 
    expect(response_body).not_to include resource 
  end

  it 'returns status 401' do 
    expect(response_status).to eql 401
  end
end