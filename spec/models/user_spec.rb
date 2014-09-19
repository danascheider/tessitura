require 'spec_helper'

describe User do 
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
    let(:user) { FactoryGirl.create(:user, first_name: 'Jacob', last_name: 'Smith') }

    it { is_expected.to respond_to(:admin?) }

    it { is_expected.to respond_to(:default_task_list) }

    it { is_expected.to respond_to(:owner_id)}

    describe '#tasks' do 
      before(:each) do 
        FactoryGirl.create_list(:task_list_with_tasks, 2, user_id: user.id)
      end

      it 'returns an array' do 
        expect(user.tasks).to be_an(Array)
      end

      it 'returns all its tasks' do 
        tasks = user.task_lists.map {|list| list.tasks }
        expect(user.tasks.to_a).to eql tasks
      end
    end

    describe '#to_hash' do 
      before(:each) do 
        FactoryGirl.create(:task_list_with_tasks, user_id: user.id)
        @hash = { id:         user.id,
                  username:   user.username,
                  email:      user.email,
                  first_name: 'Jacob', 
                  last_name:  'Smith', 
                  country:    'USA',
                  task_lists: user.task_lists.map {|list| list.id },
                  created_at: user.created_at
                }
      end

      it 'returns a hash of its attributes' do 
        expect(user.to_hash).to eql @hash
      end
    end

    describe '#name' do 
      it 'concatenates first and last name' do 
        expect(user.name).to eql 'Jacob Smith'
      end
    end

    describe '#default_task_list' do 
      it 'creates a task list if there isn\'t one' do 
        expect { user.default_task_list }.to change { user.task_lists.count }.from(0).to(1)
      end

      it 'returns its first task list' do 
        3.times { FactoryGirl.create(:task_list, user_id: user.id) }
        expect(user.default_task_list).to eql user.task_lists.first
      end
    end

    describe '#owner_id' do 
      it 'returns its own ID' do 
        expect(user.owner_id).to eql user.id
      end
    end
  end

  describe 'creating users' do 
    context 'validations' do 
      let(:admin) { FactoryGirl.create(:admin, email: 'admin@example.com') }
      let(:user) { FactoryGirl.build(:user, email: nil) }
      
      it 'is invalid without an e-mail address' do 
        expect(user).not_to be_valid
      end

      it 'is invalid with a duplicate e-mail address' do 
        user.email = admin.email
        expect(user).not_to be_valid
      end

      it 'is invalid with an improper e-mail format' do 
        user.email = 'hello_world.com'
        expect(user).not_to be_valid
      end
    end

    context 'when a regular user account is created' do 
      it 'is not an admin' do 
        expect(FactoryGirl.create(:user)).not_to be_admin
      end
    end
  end

  describe 'admin scope' do 
    before(:each) do
      @admins = FactoryGirl.create_list(:admin, 2).flatten
    end

    it 'includes all the admins' do 
      expect(User.admin.to_a).to eql @admins
    end
  end

  describe 'admin deletion' do 
    before(:each) do 
      @admin_1 = FactoryGirl.create(:admin)
    end

    context 'last admin' do 
      it 'doesn\'t destroy the last admin' do 
        expect{ @admin_1.destroy }.to raise_error(Sequel::HookFailed)
      end
    end

    context 'not last admin' do 
      before(:each) do 
        @admin_2 = FactoryGirl.create(:admin)
      end

      it 'destroys user' do 
        expect{ @admin_2.destroy }.not_to raise_error
      end
    end
  end
end