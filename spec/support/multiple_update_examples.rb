shared_examples 'an authorized multiple update' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do 
    it 'updates all the models' do 
      put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'

      # model.class[model.id] refreshes the model stored in the array
      # If I just use `model` it doesn't work.

      a = models.map {|model| [ model.class[model.id], valid_attributes[models.index(model)] ] }

      a.each do |arr|
        arr[1].each {|key, value| expect(arr[0].send(key)).to eql value }
      end
    end

    it 'returns status 200' do 
      put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql 200
    end
  end

  context 'with invalid attributes' do 
    it 'doesn\'t persist any changes' do 
      models.each {|model| expect(model).not_to receive(:save) }
      put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it 'reverts even valid models' do 
      put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'

      invalid_attributes.each do |hash|
        i = invalid_attributes.index(hash)
        hash.reject! {|key, value| key === :id }
        hash.each {|key, value| expect(models[i].class[models[i].id].send(key)).not_to eql value }
      end
    end

    it 'returns status 422' do 
      put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eql 422
    end
  end
end

shared_examples 'an unauthorized multiple update' do 
  before(:each) do 
    authorize username, password
  end

  it 'returns status 401' do 
    put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
    expect(last_response.status).to eql 401
  end

  it 'doesn\'t call ::set' do 
    expect_any_instance_of(Task).not_to receive(:set)
    put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
  end
end