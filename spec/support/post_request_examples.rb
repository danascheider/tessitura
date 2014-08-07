shared_examples 'an authorized POST request' do 
  context 'with valid attributes' do 
    it 'creates a resource' do 
      expect(model).to receive(:create!)
      authorize_with agent
      make_request('POST', path, valid_attributes)
    end

    it 'returns status 201' do 
      authorize_with agent
      make_request('POST', path, valid_attributes)
      expect(response_status).to eql 201
    end
  end

  context 'with invalid attributes' do 
    it 'returns status 422' do 
      authorize_with agent
      make_request('POST', path, invalid_attributes)
      expect(response_status).to eql 422
    end
  end
end

shared_examples 'an unauthorized POST request' do 
  it 'doesn\'t create a resource' do 
    expect(model).not_to receive(:create!)
    authorize_with agent
    make_request('POST', path, valid_attributes)
  end

  it 'returns status 401' do 
    authorize_with agent
    make_request('POST', path, valid_attributes)
    expect(response_status).to eql 401
  end
end

shared_examples 'a POST request without credentials' do 
  it 'doesn\'t create a resource' do 
    expect(model).not_to receive(:create!)
    make_request('POST', path, valid_attributes)
  end

  it 'returns status 401' do 
    make_request('POST', path, valid_attributes)
    expect(response_status).to eql 401
  end
end