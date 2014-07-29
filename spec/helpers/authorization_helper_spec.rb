require 'spec_helper'

describe Canto::AuthorizationHelper do 
  include Canto::AuthorizationHelper

  before(:all) do 
    FactoryGirl.create_list(:user_with_task_lists, 2)
    @admin, @user = User.first, User.last
    @admin.update(admin: true)
  end

  describe '::user_match?' do 
    context 'when the user matches' do 
      it 'returns true' do 
        expect(user_match?(@admin.id, @admin.secret_key)).to eql true
      end
    end

    context 'when the user doesn\'t match' do 
      it 'returns false' do 
        expect(user_match?(@user.id, @admin.secret_key)).to eql false
      end
    end
  end

  describe '::admin_approved?' do 
    context 'when the key belongs to an admin' do 
      it 'returns true' do 
        expect(admin_approved?(@admin.secret_key)).to eql true
      end
    end

    context 'when the key belongs to a normal user' do 
      it 'returns false' do 
        expect(admin_approved?(@user.secret_key)).to eql false
      end
    end
  end

  describe '::create_authorized?' do 
    context 'when not creating an admin' do 
      it 'returns true' do 
        expect(create_authorized?({email: 'elspeth@example.com'})).to eql true
      end
    end

    context 'when creating an admin' do 
      context 'legally' do 
        it 'returns true' do
          body = {admin: true, secret_key: @admin.secret_key }
          expect(create_authorized?(body)).to eql true
        end
      end

      context 'with no key provided' do 
        it 'returns false' do 
          expect(create_authorized?({admin: true})).to eql false
        end
      end

      context 'with unauthorized key provided' do 
        it 'returns false' do
          expect(create_authorized?({admin: true, secret_key: @user.secret_key})).to eql false
        end
      end
    end
  end

  describe '::read_authorized?' do 
    context 'with user\'s secret key' do 
      it 'returns true' do 
        expect(read_authorized?(@user.id, {secret_key: @user.secret_key})).to eql true
      end
    end

    context 'with admin\'s secret key' do 
      it 'returns true' do 
        expect(read_authorized?(@user.id, { secret_key: @admin.secret_key })).to eql true
      end
    end

    context 'without secret key' do 
      it 'returns false' do 
        expect(read_authorized?(@user.id, { email: 'eve@example.com' })).to eql false
      end
    end

    context 'with wrong user\'s key' do 
      it 'returns false' do 
        expect(read_authorized?(@admin.id, { secret_key: @user.secret_key })).to eql false
      end
    end
  end

  describe '::update_authorized?' do 
    context 'with user\'s secret key provided' do 
      it 'returns true' do 
        expect(update_authorized?(@user.id, secret_key: @user.secret_key)).to eql true
      end
    end

    context 'with admin\'s secret key provided' do 
      it 'returns true' do 
        expect(update_authorized?(@user.id, secret_key: @admin.secret_key)).to eql true
      end
    end

    context 'with no secret key provided' do 
      it 'returns false' do 
        expect(update_authorized?(@user.id, email: 'eve@example.com')).to eql false
      end
    end

    context 'with an unauthorized key provided' do 
      it 'returns false' do 
        expect(update_authorized?(@admin.id, secret_key: @user.secret_key)).to eql false
      end
    end
  end

  describe '::delete_authorized?' do 
    context 'with user\'s secret key provided' do 
      it 'returns true' do 
        expect(delete_authorized?(@user.id, secret_key: @user.secret_key)).to eql true
      end
    end

    context 'with admin\'s secret key provided' do 
      it 'returns true' do 
        expect(delete_authorized?(@user.id, secret_key: @admin.secret_key)).to eql true
      end
    end

    context 'with no secret key provided' do 
      it 'returns false' do 
        expect(delete_authorized?(@user.id)).to eql false
      end
    end

    context 'with an unauthorized key provided' do 
      it 'returns false' do 
        expect(delete_authorized?(@admin.id, secret_key: @user.secret_key)).to eql false
      end
    end
  end
end