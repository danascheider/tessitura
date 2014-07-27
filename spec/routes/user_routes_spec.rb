require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  before(:each) do 
    FactoryGirl.create(:admin)
  end

  describe 'POST' do 
    context 'with valid attributes' do 
      before(:each) do
        make_request('POST', '/users', { 'email' => 'user@example.com', 'country' => 'USA' }.to_json)
      end

      it 'returns an API key' do 
        expect(response_body).to include('secret_key')
      end

      it 'returns status 201' do 
        expect(response_status).to eql 201
      end
    end

    context 'with invalid attributes' do 
      it 'returns status 422' do 
        make_request('POST', '/users', { 'first_name' => 'Frank' }.to_json)
        expect(response_status).to eql 422
      end
    end

    context 'making an admin' do 
      context 'with admin key included in the request' do
        before(:each) do
          make_request('POST', '/users', { 'secret_key' => User.first.secret_key, 'email' => 'joe@example.com', 'admin' => true }.to_json)
        end 

        it 'makes an admin' do 
          expect(User.find_by(email: 'joe@example.com')).to be_admin
        end

        it 'returns status 201' do 
          expect(response_status).to eql 201
        end
      end

      context 'with no admin key in the request' do 
        before(:each) do 
          make_request('POST', '/users', { 'email' => 'joe@example.com', 'admin' => true }.to_json)
        end

        it 'doesn\'t create a user' do 
          expect(User.count).to eql 1
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
      end
    end
  end
end