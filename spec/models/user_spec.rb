require 'spec_helper'

describe User do 
  describe 'attributes' do 
    it { should respond_to(:first_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:email) }
    it { should respond_to(:birthdate) }
    it { should respond_to(:city) }
    it { should respond_to(:country) }
    it { should respond_to(:fach) }
    it { should respond_to(:admin) }
  end

  describe 'instance methods' do
    it { should respond_to(:admin?) }
    it { should respond_to(:name) }
  end

  describe 'creating users' do 
    context 'validations' do 
      before(:each) do 
        FactoryGirl.create(:user, email: 'user1@example.com')
        @user = User.new
      end

      it 'is invalid without an e-mail address' do 
        expect(@user).not_to be_valid
      end

      it 'is invalid with a duplicate e-mail address' do 
        @user.email = 'user1@example.com'
        expect(@user).not_to be_valid
      end

      it 'is invalid with an improper e-mail format' do 
        @user.email = 'hello_world.com'
        expect(@user).not_to be_valid
      end
    end

    context 'when there are no other users in the database' do 
      it 'is automatically an admin' do 
        FactoryGirl.create(:user)
        expect(User.first).to be_admin
      end
    end

    context 'when a regular user account is created' do 
      before(:each) do 
        2.times { FactoryGirl.create(:user) }
        @user = User.create!(email: 'joeblow@example.com')
      end

      it 'is not an admin' do 
        expect(@user).not_to be_admin
      end

      it 'has a secret key' do 
        expect(@user.secret_key).not_to be_nil
      end
    end
  end

  describe 'updating users' do 
    context 'validations' do 
      before(:each) do 
        @user = FactoryGirl.create(:user)
      end

      it 'can\'t delete its secret key' do 
        @user.secret_key = nil
        expect(@user).not_to be_valid
      end
    end
  end
end