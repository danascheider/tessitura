shared_examples 'an authorized multiple update' do 
  before(:each) do 
    authorize_with agent
  end

  context 'with valid attributes' do 
    it 'calls ::set_attributes' do 
      valid_attributes.each do |hash|
        index = valid_attributes.index(hash)
        puts "INDEX: #{index}"
        expect_any_instance_of(Canto).to receive(:set_attributes).with(hash, models[index])
      end

      put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
    end
  end
end