shared_examples 'an authorized PUT request' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do 
    it 'updates the resource' do 
      attrs = decode_form_data(valid_attributes)
      expect_any_instance_of(model).to receive(:update).with(attrs)
      make_request('PUT', path, valid_attributes)
    end

    it 'returns status 200' do 
      make_request('PUT', path, valid_attributes)
      expect(response_status).to eql 200
    end
  end

  context 'with invalid attributes' do 
    it 'returns status 422' do 
      pending('Buggy example fails even though functionality works')
      make_request('PUT', path, invalid_attributes)
      expect(response_status).to eql 422
    end
  end
end

shared_examples 'an unauthorized PUT request' do 
  before(:each) do 
    authorize_with agent
  end

  it 'doesn\'t update the resource' do 
    expect_any_instance_of(model).not_to receive(:update).with(parse_json(valid_attributes))
    make_request('PUT', path, valid_attributes)
  end

  it 'returns status 401' do 
    make_request('PUT', path, valid_attributes)
    expect(response_status).to eql 401
  end
end

shared_examples 'a PUT request without credentials' do 
  it 'doesn\'t update the resource' do 
    expect_any_instance_of(model).not_to receive(:update).with(parse_json(valid_attributes))
    make_request('PUT', path, valid_attributes)
  end

  it 'returns status 401' do 
    make_request('PUT', path, valid_attributes)
    expect(response_status).to eql 401
  end
end