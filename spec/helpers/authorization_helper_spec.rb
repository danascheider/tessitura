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
        body = { secret_key: @admin_key, email: 'user1@example.com', admin: true }
        expect(authorized?('POST', 'users', nil, body)).to eql true
      end

      it 'doesn\'t allow an admin to be created without an admin key' do 
        body = { email: 'user2@example.com', admin: true }
        expect(authorized?('POST', 'users', nil, body)).to eql nil
      end
    end

    describe 'conferring admin status' do 
      before(:each) do 
        @user = FactoryGirl.create(:user)
      end

      it 'allows admin to be set to true with admin key' do 
        body = { secret_key: @admin_key, admin: true }
        expect(authorized?('PUT', 'users', @user.id, body)).to eql true
      end

      it 'doesn\'t allow admin to be set to true without admin key' do 
        body = { secret_key: @user.secret_key, admin: true } 
        expect(authorized?('PUT', 'users', @user.id, body)).to eql nil
      end
    end

    describe 'viewing list of all users' do 
      it 'authorizes viewing list of users with admin key' do 
        expect(authorized?('GET', 'users', nil, { secret_key: @admin_key })).to eql true
      end

      it 'does not allow viewing list of users without admin key' do 
        expect(authorized?('GET', 'users', nil, { secret_key: 'tunafish12' })).to eql nil
      end
    end

    describe 'mass updates' do 
      before(:each) do 
        @user = FactoryGirl.create(:user)
      end

      it 'allows users to be updated with admin key' do 
        body = { secret_key: @admin_key, 'fach' => 'mezzo-soprano' }
        expect(authorized?('PUT', 'users', nil, body)).to eql true
      end

      it 'doesn\'t allow users to be updated without admin key' do 
        body = { secret_key: @user.secret_key, 'fach' => 'mezzo-soprano' }
        expect(authorized?('PUT', 'users', nil, body)).to eql false
      end
    end

    describe 'mass deletion' do 
      before(:each) do 
        3.times { FactoryGirl.create(:user) }
      end

      it 'allows all users to be deleted with admin key' do 
        expect(authorized?('DELETE', 'users', nil, { secret_key: @admin_key })).to eql true
      end

      it 'doesn\'t allow users to be deleted without admin key' do 
        expect(authorized?('DELETE', 'users', nil, { secret_key: User.last.secret_key })).to eql nil
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
        expect(authorized?('GET', 'users', @user1.id, @body)).to eql true
      end

      it 'doesn\'t allow the user to view someone else\'s profile' do 
        expect(authorized?('GET', 'users', @user2.id, @body)).to eql nil
      end
    end

    describe 'editing profile' do 
      before(:each) do 
        @body = { secret_key: @user1.secret_key, 'city' => 'Newark' } 
      end

      it 'allows the user to edit their own profile' do 
        expect(authorized?('PUT', 'users', @user1.id, @body)).to eql true
      end

      it 'doesn\'t allow the user to edit someone else\'s profile' do 
        expect(authorized?('PUT', 'users', @user2.id, @body)).to eql nil
      end
    end

    describe 'deleting profile' do 
      before(:each) do
        @body = { secret_key: @user1.secret_key }
      end

      it 'allows the user to delete their own profile' do 
        expect(authorized?('DELETE', 'users', @user1.id, @body)).to eql true
      end

      it 'doesn\'t allow the user to delete someone else\'s profile' do 
        expect(authorized?('DELETE', 'users', @user2.id, @body)).to eql nil
      end
    end
  end
end