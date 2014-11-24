shared_examples 'an authorized multiple update' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do 
    it 'calls ::set_attributes' do 
      expect_any_instance_of(Canto).to receive(:set_attributes).with(valid_attributes[0], klass[resource[0][:id]])
      expect_any_instance_of(Canto).to receive(:set_attributes).with(valid_attributes[1], klass[resource[1][:id]])
      put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
    end
  end
end