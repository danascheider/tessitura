require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  describe 'user list' do 
    let(:resource) { User.all.to_json }
    let(:path) { '/admin/users' }
    context 'with valid authorization' do 
      it_behaves_like 'an authorized GET request' do 
        let(:agent) { admin }
      end
    end

    context 'without valid authorization' do 
      it_behaves_like 'an unauthorized GET request' do 
        let(:username) { user.username }
        let(:password) { user.password }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a GET request without credentials'
    end
  end

  describe 'creating an admin' do 
    context 'with valid authorization' do 
      before(:each) do 
        authorize_with admin 
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
        authorize_with user
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