shared_examples 'an authorized DELETE request' do 
  before(:each) do 
    authorize_with agent
  end

  context 'when the resource exists' do 
    it 'deletes the resource' do 
      expect_any_instance_of(model).to receive(:destroy)
      make_request('DELETE', path)
    end

    it 'returns status 204' do 
      make_request('DELETE', path)
      expect(response_status).to eql 204
    end
  end

  context 'when the resource doesn\'t exist' do 
    it 'doesn\'t delete anything' do 
      expect_any_instance_of(model).not_to receive(:destroy)
      make_request('DELETE', nonexistent_resource_path)
    end

    it 'returns status 404' do 
      make_request('DELETE', nonexistent_resource_path)
      expect(response_status).to eql 404
    end
  end
end

shared_examples 'an unauthorized DELETE request' do 
  before(:each) do 
    authorize_with agent
  end

  it 'doesn\'t delete the resource' do 
    expect_any_instance_of(model).not_to receive(:destroy)
    make_request('DELETE', path)
  end

  it 'returns status 401' do 
    make_request('DELETE', path)
    expect(response_status).to eql 401
  end
end

shared_examples 'a DELETE request without credentials' do 
  it 'doesn\'t delete the resource' do 
    expect_any_instance_of(model).not_to receive(:destroy)
    make_request('DELETE', path)
  end

  it 'returns status 401' do 
    make_request('DELETE', path)
    expect(response_status).to eql 401
  end
end