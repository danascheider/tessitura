require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  describe 'POST' do 
    context 'with valid attributes' do 
      before(:each) do 
        make_request('POST', '/users', {'email' => 'user@example.com', 'country' => 'USA' }.to_json)
      end

      it 'returns an API key' do 
        expect(response_body).to include('secret_key')
      end

      it 'returns status code 201' do 
        expect(response_status).to eql 201
      end
    end
  end
end