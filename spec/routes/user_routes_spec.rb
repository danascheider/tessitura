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

      it 'returns status 201' do 
        expect(response_status).to eql 201
      end
    end
  end

  describe 'PUT' do 
    describe 'creating an admin' do 
      before(:each) do 
        2.times { FactoryGirl.create(:user) }
        make_request('PUT', '/users/2', { 'secret_key' => '12345abcde2', 'admin' => true }.to_json)
      end

      context 'without authorization' do 
        it 'doesn\'t make the user an admin' do 
          expect(User.find(2)).not_to be_admin
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
      end
    end
  end
end