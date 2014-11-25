shared_examples 'an authorized PUT request' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do 
    it 'updates the resource' do 
      attrs = parse_json(valid_attributes)
      expect_any_instance_of(model).to receive(:update).with(attrs)
      put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
    end

    it 'returns status 200' do 
      put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql 200
    end

    it 'returns the updated resource as a JSON object' do 
      updated = resource.update(JSON.parse(valid_attributes))
      put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.body).to eql(updated.to_json);
    end
  end

  context 'with invalid attributes' do 
    it 'returns status 422' do 
      # This example should be skipped because it fails in most cases
      # even though the functionality being tested seems to work as
      # expected. However, it can't be marked pending because it
      # passes in one scenario when admin credentials are entered.
      #
      # Efforts to investigate this issue further have come up short.
      put path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql 422
    end
  end
end

shared_examples 'an unauthorized PUT request' do 
  before(:each) do 
    authorize_with agent
  end

  it 'doesn\'t update the resource' do 
    expect_any_instance_of(model).not_to receive(:update).with(parse_json(valid_attributes))
    put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
  end

  it 'returns status 401' do 
    put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eql 401
  end
end

shared_examples 'a PUT request without credentials' do 
  it 'doesn\'t update the resource' do 
    expect_any_instance_of(model).not_to receive(:update).with(parse_json(valid_attributes))
    put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
  end

  it 'returns status 401' do 
    put path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eql 401
  end
end