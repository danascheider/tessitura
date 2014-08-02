require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  before(:each) do 
    FactoryGirl.create_list(:user_with_task_lists, 2)
    @admin, @user = User.first, User.last 
    @admin.update(admin: true)
  end

  describe 'user list' do 
    context 'with valid authorization' do 
      before(:each) do 
        authorize @admin.username, @admin.password
        make_request('GET', '/admin/users')
      end

      it 'returns a list of all the users' do 
        expect(response_body).to eql User.all.to_json
      end

      it 'returns status 200' do 
        expect(response_status).to eql 200
      end
    end

    context 'without valid authorization' do 
      before(:each) do 
        authorize @user.username, @user.password
        make_request('GET', '/admin/users')
      end

      it 'doesn\'t return any data' do 
        expect(response_body).to eql 'Authorization Required'
      end

      it 'returns status 401' do 
        expect(response_status).to eql 401
      end
    end

    context 'with no authorization' do 
      before(:each) do 
        make_request('GET', '/admin/users')
      end

      it 'doesn\'t return any data' do 
        expect(response_body).to eql 'Authorization Required' 
      end

      it 'returns status 401' do 
        expect(response_status).to eql 401
      end
    end
  end

  describe 'creating an admin' do 
    context 'with valid authorization' do 
      before(:each) do 
        authorize @admin.username, @admin.password 
      end

      it 'creates a new user' do 
        expect(User).to receive(:create!)
        make_request('POST', '/admin/users', { 'username' => 'abc123', 'password' => '12345abcde', 'email' => 'janedoe@example.com', 'admin' => true }.to_json)
      end

      it 'returns status 201' do 
        make_request('POST', '/admin/users', { 'username' => 'abc123', 'password' => '12345abcde', 'email' => 'janedoe@example.com', 'admin' => true }.to_json)
        expect(response_status).to eql 201
      end
    end

    context 'with invalid authorization' do 
      before(:each) do 
        authorize @user.username, @user.password
      end

      it 'doesn\'t create the user' do 
        expect(User).not_to receive(:create!)
        make_request('POST', '/admin/users', { 'username' => 'abc123', 'password' => '12345abcde', 'email' => 'janedoe@example.com', 'admin' => true }.to_json)
      end

      it 'returns status 401' do 
        make_request('POST', '/admin/users', { 'username' => 'abc123', 'password' => '12345abcde', 'email' => 'janedoe@example.com', 'admin' => true }.to_json)
        expect(response_status).to eql 401
      end
    end

    context 'with no authorization' do 
      it 'doesn\'t create the user' do 
        expect(User).not_to receive(:create!) 
        make_request('POST', '/admin/users', { 'username' => 'abc123', 'password' => '12345abcde', 'email' => 'janedoe@example.com', 'admin' => true }.to_json)
      end

      it 'returns status 401' do 
        make_request('POST', '/admin/users', { 'username' => 'abc123', 'password' => '12345abcde', 'email' => 'janedoe@example.com', 'admin' => true }.to_json)
        expect(response_status).to eql 401
      end
    end
  end
end