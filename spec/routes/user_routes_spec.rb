require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }
  let(:model) { User }

  describe 'POST' do 

    let(:path) { '/users' }

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
        it_behaves_like 'a POST request without credentials' do 
          let(:valid_attributes) { { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json }
        end
      end

      context 'without providing admin credentials' do 
        it_behaves_like 'an unauthorized POST request' do 
          let(:agent) { admin }
          let(:valid_attributes) { { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json }
        
      end
    end
  end

  describe 'GET' do 

    let(:resource) { user.to_json }
    let(:path) { "/users/#{user.id}" }

    context 'with user\'s credentials' do 
      it_behaves_like 'an authorized GET request' do 
        let(:agent) { user }
      end
    end

    context 'with admin credentials' do 
      it_behaves_like 'an authorized GET request' do 
        let(:agent) { admin }
      end
    end

    context 'with the wrong password' do 
      it_behaves_like 'an unauthorized GET request' do 
        let(:username) { user.username }
        let(:password) { 'foobar' }
      end
    end

    context 'with invalid credentials' do 
      it_behaves_like 'an unauthorized GET request' do 
        let(:resource) { admin.to_json }
        let(:username) { user.username }
        let(:password) { user.password }
        let(:path) { "/users/#{admin.id}" }
      end
    end

    context 'with no credentials' do 
      it_behaves_like 'a GET request without credentials' do 
        let(:resource) { user.to_json }
        let(:path) { "/users/#{user.id}" }
      end
    end

    context 'when the user doesn\'t exist' do 
      it 'returns status 404' do 
        authorize_with admin
        make_request('GET', '/users/1000000')
        expect(response_status).to eql 404
      end
    end
  end

  describe 'PUT' do 
    let(:path) { "/users/#{user.id}" }
    let(:valid_attributes) { { fach: 'lyric spinto' }.to_json }
    let(:invalid_attributes) { { username: nil }.to_json }

    context 'with user credentials' do 
      it_behaves_like 'an authorized PUT request' do 
        let(:agent) { user }
      end

      context 'attempting to set admin status to true' do 
        it 'doesn\'t update the profile' do 
          expect_any_instance_of(User).not_to receive(:update!)
          make_request('PUT', "/users/#{user.id}", { 'admin' => true }.to_json)
        end

        it 'returns status 401' do 
          make_request('PUT', "/users/#{user.id}", { 'admin' => true }.to_json)
          expect(response_status).to eql 401
        end
      end
    end

    context 'with admin credentials' do 
      it_behaves_like 'an authorized PUT request' do 
        let(:agent) { admin }
      end
    end

    context 'with invalid credentials' do 
      it_behaves_like 'an unauthorized POST request' do 
        let(:agent) { user }
        let(:path) { "/users/#{admin.id}" }
      end
    end

    context 'with no credentials' do 
      it_behaves_like 'a PUT request without credentials'
    end

    context 'when the user doesn\'t exist' do 
      it 'returns status 404' do 
        authorize_with admin
        make_request('PUT', '/users/1000000', { "fach" => "lyric coloratura" }.to_json)
        expect(response_status).to eql 404
      end
    end
  end

  describe 'DELETE' do 
    let(:path) { "/users/#{user.id}" }

    context 'with user credentials' do 
      it_behaves_like 'an authorized DELETE request' do 
        let(:agent) { user }
        let(:nonexistent_resource_path) { "/users/1000000"}
      end
    end

    context 'with admin credentials' do 
      it_behaves_like 'an authorized DELETE request' do 
        let(:agent) { admin }
        let(:nonexistent_resource_path) { "/users/1000000"}
      end
    end

    context 'with invalid credentials' do 
      it_behaves_like 'an unauthorized DELETE request' do 
        let(:path) { "/users/#{admin.id}" }
        let(:agent) { user }
      end
    end

    context 'with no credentials' do 
      it_behaves_like 'a DELETE request without credentials' 
    end
  end
end