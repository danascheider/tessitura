require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  before(:each) do 
    DatabaseCleaner.clean_with(:truncation)
    FactoryGirl.create_list(:user_with_task_lists, 2)
    @admin, @user = User.first, User.last
    @admin.update(admin: true)
  end

  describe 'POST' do 
    context 'with valid attributes' do 
      before(:each) do
        make_request('POST', '/users', { 'email' => 'user@example.com', 'username' => 'justine', 'password' => 'validpassword666', 'country' => 'USA' }.to_json)
      end

      it 'calls the User create method' do 
        expect(User).to receive(:create)
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

  describe 'GET' do 
    context 'with user\'s secret key' do 
      before(:each) do 
        make_request('GET', "/users/#{@user.id}", { secret_key: @user.secret_key }.to_json)
      end

      it 'returns the user\'s profile' do 
        expect(response_body).to eql @user.to_json
      end

      it 'returns status code 200' do 
        expect(response_status).to eql 200
      end
    end

    context 'with admin\'s secret key' do 
      before(:each) do 
        make_request('GET', "/users/#{@user.id}", { secret_key: @admin.secret_key }.to_json)
      end

      it 'returns the user\'s profile' do 
        expect(response_body).to eql @user.to_json
      end

      it 'returns status code 200' do 
        expect(response_status).to eql 200
      end
    end

    context 'with unauthorized key' do 
      before(:each) do
        make_request('GET', "/users/#{@admin.id}", { secret_key: @user.secret_key }.to_json)
      end

      it 'doesn\'t return the user\'s profile' do 
        expect(response_body).not_to include @admin.to_json
      end

      it 'returns status code 401' do 
        expect(response_status).to eql 401
      end
    end

    context 'with no secret key' do 
      before(:each) do 
        make_request('GET', "/users/#{@user.id}")
      end

      it 'doesn\'t return the user\'s profile' do 
        expect(response_body).not_to include @user.to_json
      end

      it 'returns status code 401' do 
        expect(response_status).to eql 401
      end
    end
  end
end