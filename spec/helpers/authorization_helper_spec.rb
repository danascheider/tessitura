require 'spec_helper' 

describe Canto::AuthorizationHelper do 
  include Canto::AuthorizationHelper

  describe '::authorized_credentials?' do 
    before(:each) do 
      FactoryGirl.create_list(:user, 2)
      @admin, @user = User.first, User.last
    end

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
end