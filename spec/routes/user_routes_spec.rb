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
      it 'calls the User create! method' do 
        expect(User).to receive(:create!)
        make_request('POST', '/users', { 'email' => 'user@example.com', 'username' => 'justine', 'password' => 'validpassword666', 'country' => 'USA' }.to_json)
      end

      it 'returns status 201' do 
        make_request('POST', '/users', { 'email' => 'user@example.com', 'username' => 'justine', 'password' => 'validpassword666', 'country' => 'USA' }.to_json)
        expect(response_status).to eql 201
      end
    end

    context 'with invalid attributes' do 
      it 'attempts to create a user' do 
        expect(User).to receive(:create!)
        make_request('POST', '/users', { 'first_name' => 'Frank' }.to_json)
      end

      it 'returns status 422' do 
        make_request('POST', '/users', { 'first_name' => 'Frank' }.to_json)
        expect(response_status).to eql 422
      end
    end

    context 'attempting to create an admin' do 
      context 'without providing credentials'
        it 'doesn\'t create a user' do 
          expect(User).not_to receive(:create!)
          make_request('POST', '/users', { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json)
        end

        it 'returns status 401' do 
          make_request('POST', '/users', { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json)
          expect(response_status).to eql 401
          puts last_response.body
        end
      end

      context 'without providing admin credentials' do 
        it 'doesn\'t create a user' do 
          expect(User).not_to receive(:create!)
          authorize @user.username, @user.password
          make_request('POST', '/users', { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json)
        end

        it 'returns status 401' do 
          make_request('POST', '/users', { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json)
          expect(response_status).to eql 401
      end
    end

  end

  describe 'GET' do 
    context 'with user\'s credentials' do 
      before(:each) do 
        authorize @user.username, @user.password
        make_request('GET', "/users/#{@user.id}")
      end

      it 'returns the user\'s profile' do 
        expect(response_body).to eql @user.to_json
      end

      it 'returns status code 200' do 
        expect(response_status).to eql 200
      end
    end

    context 'with admin credentials' do 
      before(:each) do 
        authorize @admin.username, @admin.password
        make_request('GET', "/users/#{@user.id}")
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
        authorize @user.username, @user.password
        make_request('GET', "/users/#{@admin.id}")
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