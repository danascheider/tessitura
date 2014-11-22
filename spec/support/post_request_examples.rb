shared_examples 'an authorized POST request' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do
    it 'creates a resource' do 
      expect(model).to receive(:try_rescue).with(:create, parse_json(valid_attributes))
      post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
    end

    it 'returns the resource as a JSON object'

    it 'returns status 201' do 
      post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql 201
    end
  end

  context 'with invalid attributes' do 
    it 'does not create the resource' do 
      expect(model).to receive(:try_rescue).and_return(nil)
      post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
    end

    it 'returns status 422' do 
      post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql 422
    end

    it 'does not return a response body' do 
      post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.body).to be_blank
    end
  end
end

shared_examples 'an unauthorized POST request' do 
  before(:each) do 
    authorize_with agent
  end

  it 'doesn\'t create a resource' do 
    expect(model).not_to receive(:create)
    post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
  end

  it 'returns status 401' do 
    post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eql 401
  end
end

shared_examples 'a POST request without credentials' do 
  it 'doesn\'t create a resource' do 
    expect(model).not_to receive(:create)
    post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
  end

  it 'returns status 401' do 
    post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eql 401
  end
end