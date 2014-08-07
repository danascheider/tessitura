require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }

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
          authorize_with user
          make_request('POST', '/users', { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json)
        end

        it 'returns status 401' do 
          make_request('POST', '/users', { 'username' => 'someuser', 'password' => 'someuserpasswd', 'email' => 'peterpiper@example.com', 'admin' => true }.to_json)
          expect(response_status).to eql 401
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
    context 'with user credentials' do 
      before(:each) do 
        authorize_with user
      end

      context 'with valid attributes' do 
        it 'updates the profile' do 
          expect_any_instance_of(User).to receive(:update!)
          make_request('PUT', "/users/#{user.id}", { 'fach' => 'soprano' }.to_json)
        end

        it 'returns status 200' do 
          make_request('PUT', "/users/#{user.id}", { 'fach' => 'soprano' }.to_json)
        end
      end

      context 'with invalid attributes' do 
        it 'returns status 422' do 
          make_request('PUT', "/users/#{user.id}", { 'email' => nil }.to_json)
          expect(response_status).to eql 422
        end
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
      before(:each) do 
        authorize_with admin
      end

      it 'updates the profile' do 
        expect_any_instance_of(User).to receive(:update!)
        make_request('PUT', "/users/#{user.id}", { 'admin' => true }.to_json)
      end

      it 'returns status 200' do 
        make_request('PUT', "/users/#{user.id}", { 'admin' => true }.to_json)
        expect(response_status).to eql 200
      end
    end

    context 'with invalid credentials' do 
      before(:each) do 
        authorize_with user
      end

      it 'doesn\'t update the profile' do 
        expect_any_instance_of(User).not_to receive(:update!)
        make_request('PUT', "/users/#{admin.id}", { 'country' => 'Kyrgyzstan' })
      end

      it 'returns status 401' do 
        make_request('PUT', "/users/#{admin.id}", { 'country' => 'Kyrgyzstan' })
        expect(response_status).to eql 401
      end
    end

    context 'with no credentials' do 
      it 'doesn\'t update the profile' do 
        expect_any_instance_of(User).not_to receive(:update!)
        make_request('PUT', "/users/#{user.id}", { 'last_name' => 'Seligman' }.to_json)
      end

      it 'returns status 401' do 
        make_request('PUT', "/users/#{user.id}", { 'last_name' => 'Seligman' }.to_json)
        expect(response_status).to eql 401
      end 
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
    context 'with user credentials' do 
      before(:each) do 
        authorize_with user
      end

      it 'deletes the profile' do 
        expect_any_instance_of(User).to receive(:destroy!)
        make_request('DELETE', "/users/#{user.id}")
      end

      it 'returns status 204' do 
        make_request('DELETE', "/users/#{user.id}")
        expect(response_status).to eql 204
      end
    end

    context 'with admin credentials' do 
      before(:each) do 
        authorize_with admin
      end

      it 'deletes the user' do 
        expect_any_instance_of(User).to receive(:destroy!)
        make_request('DELETE', "/users/#{user.id}")
      end

      it 'returns status 204' do 
        make_request('DELETE', "/users/#{user.id}")
        expect(response_status).to eql 204
      end
    end

    context 'with invalid credentials' do 
      before(:each) do 
        authorize_with user
      end

      it 'doesn\'t delete the user' do 
        expect_any_instance_of(User).not_to receive(:destroy!)
        make_request('DELETE', "/users/#{admin.id}")
      end

      it 'returns status 401' do 
        make_request('DELETE', "/users/#{admin.id}")
        expect(response_status).to eql 401
      end
    end

    context 'with no credentials' do 
      it 'doesn\'t delete the user' do 
        expect_any_instance_of(User).not_to receive(:destroy!)
        make_request('DELETE', "/users/#{user.id}")
      end

      it 'returns status 401' do 
        make_request('DELETE', "/users/#{user.id}")
        expect(response_status).to eql 401
      end
    end

    context 'when the user doesn\'t exist' do 
      it 'returns status 404' do 
        authorize_with admin
        make_request('DELETE', '/users/1000000')
        expect(response_status).to eql 404
      end
    end
  end
end