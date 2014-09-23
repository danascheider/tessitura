require 'spec_helper'

describe User do 
  include Sinatra::ErrorHandling

  describe 'attributes' do 
    it { is_expected.to respond_to(:first_name) }
    it { is_expected.to respond_to(:last_name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:birthdate) }
    it { is_expected.to respond_to(:city) }
    it { is_expected.to respond_to(:country) }
    it { is_expected.to respond_to(:fach) }
    it { is_expected.to respond_to(:admin) }
    it { is_expected.to respond_to(:to_json) }
  end

  describe 'class methods' do 
    describe '#create' do 
      context 'with valid attributes' do 
        let(:attributes) { { username: 'usernumber1', password: 'usernumber1', email: 'u1@a.com' } }

        it 'creates the user' do 
          expect{ User.create(attributes) }.to change(User, :count).by(1)
        end

        it 'sets :admin to false' do 
          expect(User.create(attributes).admin).to be_falsey
        end
      end

      context 'with invalid attributes' do 
        let(:attributes) { { username: 'foo' } }

        it 'doesn\'t create a user' do 
          count = User.count; User.create(attributes) rescue Sequel::ValidationFailed
          expect(User.count).to eql count
        end

        it 'raises Sequel::ValidationFailed' do 
          expect{ User.create(attributes) }.to raise_error(Sequel::ValidationFailed)
        end
      end

      context 'validations' do 
        let(:admin) { FactoryGirl.create(:admin, email: 'admin@example.com') }
        let(:user) { FactoryGirl.build(:user) }

        context 'username and password validations' do 
          it 'is invalid without a username' do 
            user.username = nil
            expect(user).not_to be_valid
          end

          it 'is invalid without a password' do 
            user.username, user.password = 'valid_username', nil
            expect(user).not_to be_valid
          end

          it 'is invalid with too short a username' do 
            user.username = 'amy2'
            expect(user).not_to be_valid
          end

          it 'is invalid with too short a password' do 
            user.password = 'short'
            expect(user).not_to be_valid
          end

          it 'is invalid with a duplicate username' do 
            user.username = admin.username
            expect(user).not_to be_valid
          end
        end
        
        context 'e-mail validations' do 
          it 'is invalid without an e-mail address' do 
            user.email = nil
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
      end
    end
  end

  describe 'instance methods' do
    let(:user) { FactoryGirl.create(:user, first_name: 'Jacob', last_name: 'Smith') }

    describe '#admin' do 
      context 'when the user is not an admin' do 
        it 'returns false' do 
          expect(user.admin?).to eql false
        end
      end

      context 'when the user is an admin' do 
        it 'returns true' do 
          user.update(admin: true)
          expect(user.admin?).to eql true
        end
      end
    end

    describe '#default_task_list' do 
      it 'creates a task list if there isn\'t one' do 
        expect { user.default_task_list }.to change { user.task_lists.count }.from(0).to(1)
      end

      it 'returns its first task list' do 
        2.times { FactoryGirl.create(:task_list, user_id: user.id) }
        expect(user.default_task_list).to eql user.task_lists.first
      end
    end

    describe '#destroy' do 
      before(:each) do 
        @user = FactoryGirl.create(:user_with_task_lists)
      end

      it 'deletes the user from the database' do 
        expect{ @user.destroy }.to change(User, :count).by(-1)
      end

      it 'destroys the user\'s task lists' do 
        count = @user.task_lists.count
        expect{ @user.destroy }.to change(TaskList, :count).by(-1 * count)
      end

      context 'when user is an admin' do 
        before(:each) do 
          @admin_1 = FactoryGirl.create(:admin)
        end

        context 'last admin' do 
          it 'raises Sequel::HookFailed' do 
            expect{ @admin_1.destroy }.to raise_error(Sequel::HookFailed)
          end

          it 'doesn\'t destroy the last admin' do 
            id = @admin_1.id; @admin_1.destroy rescue Sequel::HookFailed
            expect(User[id]).to be_truthy
          end
        end

        context 'not last admin' do 
          it 'destroys user' do 
            admin_2 = FactoryGirl.create(:admin)
            expect{ admin_2.destroy }.to change(User, :count).by(-1)
          end
        end
      end
    end

    describe '#remove_all_task_lists' do 
      let(:user) { FactoryGirl.create(:user_with_task_lists) }

      it 'destroys all the task lists' do 
        user.remove_all_task_lists
        expect(user.task_lists.count).to eql 0
      end
    end

    describe '#remove_task_list' do 
      let(:user) { FactoryGirl.create(:user_with_task_lists) }

      it 'deletes the list' do 
        list = user.task_lists.first
        expect{ user.remove_task_list(list) }.to change(TaskList, :count).by(-1)
      end
    end

    describe '#task_lists_dataset' do 
      let(:user) { FactoryGirl.create(:user_with_task_lists) }

      it 'returns a Sequel::Dataset object' do 
        expect(user.task_lists_dataset).to be_a(Sequel::Dataset)
      end
    end

    describe '#tasks' do 
      before(:each) do 
        FactoryGirl.create_list(:task_list_with_tasks, 2, user_id: user.id)
      end

      it 'returns an array' do 
        expect(user.tasks).to be_an(Array)
      end

      it 'returns all its tasks' do 
        tasks = user.task_lists.map {|list| list.tasks }
        expect(user.tasks).to eql tasks.flatten
      end
    end

    describe '#tasks_dataset' do 
      let(:user) { FactoryGirl.create(:user_with_task_lists) }

      it 'returns all the tasks' do 
        expect(user.tasks_dataset).to eql DB[:tasks].filter(owner_id: user.id)
      end

      it 'returns a Sequel::Dataset object' do 
        expect(user.tasks_dataset).to be_a(Sequel::Dataset)
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

    describe '#to_json' do 
      it 'converts itself to hash form first' do 
        expect(user.to_json).to eql user.to_hash.to_json
      end
    end

    describe '#name' do 
      it 'concatenates first and last name' do 
        expect(user.name).to eql 'Jacob Smith'
      end
    end

    describe '#owner_id' do 
      it 'returns its own ID' do 
        expect(user.owner_id).to eql user.id
      end
    end

    describe '#update' do 
      context 'with valid attributes' do 
        let(:attributes) { { first_name: 'Gigi', last_name: 'Eastman' } }

        it 'updates the user' do 
          user.update(attributes)
          expect([user.first_name, user.last_name]).to eql ['Gigi', 'Eastman']
        end
      end

      context 'with invalid attributes' do 
        let(:attributes) { { password: nil } }

        it 'doesn\'t update the user' do 
          password = user.password; user.update(attributes) rescue Sequel::ValidationFailed
          expect(User[user.id].password).to eql password
        end

        it 'raises an error' do 
          expect{ user.update(attributes) }.to raise_error(Sequel::ValidationFailed)
        end
      end
    end
  end

  describe 'admin scope' do 
    it 'includes all the admins' do 
      admins = FactoryGirl.create_list(:admin, 2).flatten
      expect(User.admin.to_a).to eql admins
    end
  end
end