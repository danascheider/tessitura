require 'spec_helper' 

describe Canto::AuthorizationHelper do 
  include Rack::Test::Methods
  include Canto::AuthorizationHelper

  before(:each) do 
    FactoryGirl.create_list(:user, 2)
    @admin, @user = User.first, User.last
  end

  describe '::authorized_credentials?' do 
    context 'with valid credentials' do 
      it 'returns true' do 
        expect(authorized_credentials?([@user.username, @user.password], @user.id)).to eql true
      end
    end

    context 'with admin credentials' do 
      it 'returns true' do 
        expect(authorized_credentials?([@admin.username, @admin.password], @user.id)).to eql true
      end
    end

    context 'with invalid credentials' do 
      it 'returns false' do 
        expect(authorized_credentials?([@user.username, @user.password], @admin.id)).to eql false
      end
    end
  end

  describe '::authorized?' do 
    context 'when the user is authorized' do 
      context 'as a normal user' do 
        it 'authorizes the request' do 
          authorize @user.username, @user.password
          get "/users/#{@user.id}"
          expect(response_status).to eql 200
        end
      end

      context 'as an admin' do 
        it 'authorizes the request' do 
          authorize @admin.username, @admin.password 
          get "/users/#{@user.id}"
          expect(response_status).to eql 200
        end 
      end
    end

    context 'when the user is not authorized' do 
      context 'with no credentials' do 
        it 'doesn\'t authorize the request' do
          get "/users/#{@user.id}"
          expect(response_status).to eql 401
        end
      end

      context 'with invalid username' do 
        it 'doesn\'t authorize the request' do 
          authorize 'invalid', 'invalid'
          get "/users/#{@user.id}"
          expect(response_status).to eql 401
        end
      end

      context 'with wrong password' do 
        it 'doesn\'t authorize the request' do 
          authorize @user.username, 'thisisabadpassword'
          get "/users/#{@user.id}"
          expect(response_status).to eql 401
        end
      end

      context 'trying to view someone else\'s data' do 
        it 'doesn\'t authorize the request' do 
          authorize @user.username, @user.password
          get "/users/#{@admin.id}"
          expect(response_status).to eql 401
        end
      end
    end
  end
end