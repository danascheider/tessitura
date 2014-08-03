require 'spec_helper'

describe User do 
  before(:each) do 
    @admin = FactoryGirl.create(:admin, email: 'admin@example.com')
  end

  describe 'attributes' do 
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:birthdate) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:country) }
    it { is_expected.to respond_to(:fach) }
    it { is_expected.to respond_to(:admin) }
  end

  describe 'instance methods' do
    before(:each) do 
      @user = FactoryGirl.create(:user, first_name: 'Jacob', last_name: 'Smith')
    end

    it { is_expected.to respond_to(:admin?) }

    it { is_expected.to respond_to(:default_task_list) }

    describe '#tasks' do 
      before(:each) do 
        2.times { FactoryGirl.create(:task_list_with_tasks, user_id: @user.id) }
      end

      it 'returns all its tasks' do 
        tasks = []
        @user.task_lists.each {|list| tasks << list.tasks }
        expect(@user.tasks).to eql tasks.flatten
      end
    end

    describe '#to_hash' do 
      it 'returns a hash of its attributes' do 
        expect(@user.to_hash).to eql(id: @user.id, first_name: 'Jacob', email: @user.email, last_name: 'Smith', country: 'USA')
      end
    end

    describe '#name' do 
      it 'concatenates first and last name' do 
        expect(@user.name).to eql 'Jacob Smith'
      end
    end

    describe '#default_task_list' do 
      it 'creates a task list if there isn\'t one' do 
        expect { @user.default_task_list }.to change { @user.task_lists.count }.by(1)
      end

      it 'returns its first task list' do 
        3.times { FactoryGirl.create(:task_list, user_id: @user.id) }
        expect(@user.default_task_list).to eql @user.task_lists.first
      end
    end
  end

  describe 'creating users' do 
    context 'validations' do 
      before(:each) do 
        @user = FactoryGirl.build(:user, email: nil)
      end

      it 'is invalid without an e-mail address' do 
        expect(@user).not_to be_valid
      end

      it 'is invalid with a duplicate e-mail address' do 
        @user.email = 'admin@example.com'
        expect(@user).not_to be_valid
      end

      it 'is invalid with an improper e-mail format' do 
        @user.email = 'hello_world.com'
        expect(@user).not_to be_valid
      end
    end

    context 'when a regular user account is created' do 
      it 'is not an admin' do 
        @user = FactoryGirl.create(:user, email: 'joeblow@example.com')
        expect(@user).not_to be_admin
      end
    end
  end

  describe 'admin issues' do 
    before(:each) do 
      FactoryGirl.create_list(:user, 3)
      @admins = [FactoryGirl.create_list(:admin, 2), @admin].flatten!
    end

    it 'includes all the admins' do 
      expect(User.admin.to_a.sort).to eql @admins.sort
    end
  end

  describe 'admin deletion' do 
    context 'last admin' do 
      it 'doesn\'t destroy the last admin' do 
        expect{ @admin.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
      end
    end

    context 'not last admin' do 
      before(:each) do 
        @admin_2 = FactoryGirl.create(:admin)
      end

      it 'destroys user' do 
        expect{ @admin_2.destroy! }.not_to raise_error
      end
    end
  end
end