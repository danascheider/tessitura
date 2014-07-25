require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  describe 'POST' do 
    before(:each) do 
      FactoryGirl.create(:user)
    end

    context 'with valid attributes' do 
      before(:each) do 
        make_request('POST', '/users', {'email' => 'user@example.com', 'country' => 'USA' }.to_json)
      end

      it 'returns an API key' do 
        puts "RESPONSE BODY: #{response_body}"
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
          expect(User.last).to be_admin
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

  describe 'PUT' do 
    describe 'updating a user profile' do 
      context 'when a user updates their own profile' do 
        before(:each) do 
          2.times { FactoryGirl.create(:user) }
        end

        context 'with valid attributes' do 
          before(:each) do 
            make_request('PUT', '/users/2', {'secret_key' => User.last.secret_key, 'first_name' => 'Donna', 'email' => 'donna@example.com'}.to_json)
          end

          it 'updates the user' do 
            expect(User.last.first_name).to eql 'Donna'
            expect(User.last.email).to eql 'donna@example.com'
          end

          it 'returns status 200' do 
            expect(response_status).to eql 200
          end
        end

        context 'with invalid attributes' do 
          before(:each) do 
            make_request('PUT', '/users/2', {'secret_key' => User.last.secret_key, 'first_name' => 'Donna', 'email' => nil }.to_json)
          end

          it 'doesn\'t update the record' do 
            expect(User.email).to eql 'user2@example.com'
            expect(User.first_name).to eql nil
          end

          it 'returns status 422' do 
            expect(response_status).to eql 422
          end
        end
      end
    end

    describe 'making an admin' do 
      before(:each) do 
        FactoryGirl.create(:admin)
        FactoryGirl.create(:user)
      end

      context 'without authorization' do 
        before(:each) do 
          make_request('PUT', '/users/2', {'secret_key' => User.last.secret_key, 'admin' => true }.to_json)
        end

        it 'doesn\'t make the user an admin' do 
          expect(User.find(2)).not_to be_admin
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
      end

      context 'with authorization' do 
        before(:each) do 
          make_request('PUT', '/users/2', { 'secret_key' => User.first.secret_key, 'admin' => true }.to_json)
        end

        it 'makes the user an admin' do 
          expect(User.find(2)).to be_admin
        end

        it 'returns status 200' do 
          expect(response_status).to eql 200
        end
      end
    end
  end
end