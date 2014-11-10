shared_examples 'an authorized GET request' do 
  before(:each) do 
    authorize_with agent
    make_request('GET', path)
  end

  it 'returns the requested resource' do 
    expect(last_response.body).to eql resource.to_json
  end

  it 'indicates content type text/html' do 
    # NOTE: This originally was supposed to indicate content type JSON,
    #       but that was causing a problem for the front end the nature
    #       of which, frankly, I don't remember and can't find records
    #       of in the logs. It is aesthetically offensive to have a JSON
    #       API return a content type header indicating text/html so I
    #       will look into this eventually. 
    expect(last_response.original_headers['Content-Type']).to eql 'text/html;charset=utf-8'
  end

  it 'returns status 200' do 
    expect(response_status).to eql 200
  end
end

shared_examples 'an unauthorized GET request' do 
  before(:each) do 
    authorize username, password
    make_request('GET', path)
  end

  it 'doesn\'t return the requested resource' do 
    expect(last_response.body).not_to include resource.to_json
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
    expect(last_response.body).not_to include resource.to_json
  end

  it 'returns status 401' do 
    expect(response_status).to eql 401
  end
end