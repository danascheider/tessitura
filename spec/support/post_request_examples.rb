shared_examples 'an authorized POST request' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do
    it 'creates a resource' do 
      # I really want to specify that model should be created with the
      # valid_attributes hash as an argument. But the task_list_id has to 
      # be added in the route, since the model will not know the user 
      # otherwise.

      expect(model).to receive(:create)
      make_request('POST', path, valid_attributes)
    end

    it 'returns status 201' do 
      make_request('POST', path, valid_attributes)
      expect(response_status).to eql 201
    end

    it 'changes the task count by 1' do 
      #
    end
  end

  context 'with invalid attributes' do 
    it 'returns status 422' do 
      make_request('POST', path, invalid_attributes)
      expect(response_status).to eql 422
    end
  end
end

shared_examples 'an unauthorized POST request' do 
  before(:each) do 
    authorize_with agent
  end

  it 'doesn\'t create a resource' do 
    expect(model).not_to receive(:create)
    make_request('POST', path, valid_attributes)
  end

  it 'returns status 401' do 
    make_request('POST', path, valid_attributes)
    expect(response_status).to eql 401
  end
end

shared_examples 'a POST request without credentials' do 
  it 'doesn\'t create a resource' do 
    expect(model).not_to receive(:create)
    make_request('POST', path, valid_attributes)
  end

  it 'returns status 401' do 
    make_request('POST', path, valid_attributes)
    expect(response_status).to eql 401
  end
end