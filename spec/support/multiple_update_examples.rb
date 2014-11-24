shared_examples 'an authorized multiple update' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do 
    it 'calls ::set_attributes' do 
      valid_attributes.each do |hash|
        index = valid_attributes.index(hash)
        expect_any_instance_of(Canto).to receive(:set_attributes).with(hash, models[index])
      end

      put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it 'saves the models' do 
      put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'

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
  end
end