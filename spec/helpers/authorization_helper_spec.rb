require 'spec_helper'

describe Canto::AuthorizationHelper do 
  include Canto::AuthorizationHelper

  before(:all) do 
    @admin = FactoryGirl.create(:admin)
    @admin_key = @admin.secret_key
    @admin_id = @admin.id
  end

  describe 'admin-only actions' do 
    describe 'creating a new admin' do 
      it 'allows an admin to be created with an admin key' do 
        expect(create_authorized?({ secret_key: @admin_key, email: 'user1@example.com', admin: true })).to eql true
      end

      it 'doesn\'t allow an admin to be created without an admin key' do 
        expect(create_authorized?({ email: 'user2@example.com', admin: true })).to eql false
      end
    end

    describe 'conferring admin status' do 
      before(:each) do 
        @user = FactoryGirl.create(:user)
      end

      it 'allows admin to be set to true with admin key' do 
        body = { secret_key: @admin_key, admin: true }
        expect(update_authorized?(@user.id, body)).to eql true
      end

      it 'doesn\'t allow admin to be set to true without admin key' do 
        body = { secret_key: @user.secret_key, admin: true } 
        expect(update_authorized?(@user.id, body)).to eql false
      end
    end
  end

  describe 'owner-only actions' do 
    before(:each) do 
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
    end

    describe 'viewing profile' do 
      before(:each) do 
        @body = { secret_key: @user1.secret_key }
      end

      it 'allows the user to view their own profile' do 
        expect(read_authorized?(@user1.id, @body)).to eql true
      end

      it 'doesn\'t allow the user to view someone else\'s profile' do 
        expect(read_authorized?(@user2.id, @body)).to eql false
      end
    end

    describe 'editing profile' do 
      before(:each) do 
        @body = { secret_key: @user1.secret_key, 'city' => 'Newark' } 
      end

      it 'allows the user to edit their own profile' do 
        expect(update_authorized?(@user1.id, @body)).to eql true
      end

      it 'doesn\'t allow the user to edit someone else\'s profile' do 
        expect(update_authorized?(@user2.id, @body)).to eql false
      end
    end

    describe 'deleting profile' do 
      before(:each) do
        @body = { secret_key: @user1.secret_key }
      end

      it 'allows the user to delete their own profile' do 
        expect(delete_authorized?(@user1.id, @body)).to eql true
      end

      it 'doesn\'t allow the user to delete someone else\'s profile' do 
        expect(delete_authorized?(@user2.id, @body)).to eql false
      end
    end
  end
end