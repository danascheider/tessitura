require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  describe 'POST' do 
    context 'with valid attributes' do 
      it 'returns an API code' do 
        expect(response_body).to have_key("secret_key")
      end

      it 'returns status code 201' do 
        expect(response_status).to eql 201
      end
    end
  end
end