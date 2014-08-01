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

    context 'with invalid credentials' do 
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

  describe 'PUT' do 
    context 'with user credentials' do 
      before(:each) do 
        authorize @user.username, @user.password
      end

      context 'with valid attributes' do 
        it 'updates the profile' do 
          expect_any_instance_of(User).to receive(:update!)
          puts "THE USER IN QUESTION: #{@user.to_hash}"
          puts "THE USER'S ID: #{@user.id}"
          make_request('PUT', "/users/#{@user.id}", { 'fach' => 'soprano' }.to_json)
        end

        it 'returns status 200' do 
          make_request('PUT', "/users/#{@user.id}", { 'fach' => 'soprano' }.to_json)
        end
      end

      context 'with invalid attributes' do 
        it 'returns status 422' do 
          make_request('PUT', "/users/#{@user.id}", { 'email' => nil }.to_json)
          expect(response_status).to eql 422
        end
      end

      context 'attempting to set admin status to true' do 
        it 'doesn\'t update the profile' do 
          expect_any_instance_of(User).not_to receive(:update!)
          make_request('PUT', "/users/#{@user.id}", { 'admin' => true }.to_json)
        end

        it 'returns status 401' do 
          make_request('PUT', "/users/#{@user.id}", { 'admin' => true }.to_json)
          expect(response_status).to eql 401
        end
      end
    end

    context 'with admin credentials' do 
      before(:each) do 
        authorize @admin.username, @admin.password
      end

      it 'updates the profile' do 
        expect_any_instance_of(User).to receive(:update!)
        make_request('PUT', "/users/#{@user.id}", { 'admin' => true }.to_json)
      end

      it 'returns status 200' do 
        make_request('PUT', "/users/#{@user.id}", { 'admin' => true }.to_json)
        expect(response_status).to eql 200
      end
    end

    context 'with invalid credentials' do 
      before(:each) do 
        authorize @user.username, @user.password
      end

      it 'doesn\'t update the profile' do 
        expect_any_instance_of(User).not_to receive(:update!)
        make_request('PUT', "/users/#{@admin.id}", { 'country' => 'Kyrgyzstan' })
      end

      it 'returns status 401' do 
        make_request('PUT', "/users/#{@admin.id}", { 'country' => 'Kyrgyzstan' })
        expect(response_status).to eql 401
      end
    end

    context 'with no credentials' do 
      it 'doesn\'t update the profile' do 
        expect_any_instance_of(User).not_to receive(:update!)
        make_request('PUT', "/users/#{@user.id}", { 'last_name' => 'Seligman' }.to_json)
      end

      it 'returns status 401' do 
        make_request('PUT', "/users/#{@user.id}", { 'last_name' => 'Seligman' }.to_json)
        expect(response_status).to eql 401
      end 
    end
  end

  describe 'DELETE' do 
    context 'with user credentials' do 
      before(:each) do 
        authorize @user.username, @user.password
      end

      it 'deletes the profile' do 
        expect_any_instance_of(User).to receive(:destroy!)
        make_request('DELETE', "/users/#{@user.id}")
      end

      it 'returns status 204' do 
        make_request('DELETE', "/users/#{@user.id}")
        expect(response_status).to eql 204
      end
    end

    context 'with admin credentials' do 
      before(:each) do 
        authorize @admin.username, @admin.password
      end

      it 'deletes the user' do 
        expect_any_instance_of(User).to receive(:destroy!)
        make_request('DELETE', "/users/#{@user.id}")
      end

      it 'returns status 204' do 
        make_request('DELETE', "/users/#{@user.id}")
        expect(response_status).to eql 204
      end
    end

    context 'with invalid credentials' do 
      before(:each) do 
        authorize @user.username, @user.password
      end

      it 'doesn\'t delete the user' do 
        expect_any_instance_of(User).not_to receive(:destroy!)
        make_request('DELETE', "/users/#{@admin.id}")
      end

      it 'returns status 401' do 
        make_request('DELETE', "/users/#{@admin.id}")
        expect(response_status).to eql 401
      end
    end

    context 'with no credentials' do 
      it 'doesn\'t delete the user' do 
        expect_any_instance_of(User).not_to receive(:destroy!)
        make_request('DELETE', "/users/#{@user.id}")
      end

      it 'returns status 401' do 
        make_request('DELETE', "/users/#{@user.id}")
        expect(response_status).to eql 401
      end
    end
  end
end