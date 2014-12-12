require 'spec_helper'

describe Task do 
  include Sinatra::ErrorHandling
  
  let(:task) { FactoryGirl.create(:task) }

  describe 'attributes' do 
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:status) }
    it { is_expected.to respond_to(:deadline) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:priority) }
    it { is_expected.to respond_to(:backlog) }
    it { is_expected.to respond_to(:owner_id) }
    it { is_expected.to respond_to(:position) }
  end

  describe 'class methods' do 
    let(:user) { FactoryGirl.create(:user) }
    let(:list) { FactoryGirl.create(:task_list, user_id: user.id) }

    describe '::create' do 
      context 'with valid attributes' do 
        let(:attributes) { { title: 'My Task', task_list_id: list.id } }

        it 'creates a task' do 
          expect { Task.create(attributes) }.to change(Task, :count).by(1)
        end
      end

      context 'without valid attributes' do 
        let(:attributes) { { deadline: Time.now.utc } }

        it 'doesn\'t create the task' do 
          expect { 
            Task.create(attributes) rescue Sequel::ValidationFailed 
          }.not_to change(Task, :count)
        end

        it 'raises a validation error' do 
          expect{ Task.create(attributes) }.to raise_error(Sequel::ValidationFailed)
        end
      end

      describe 'validations' do 
        let(:task) { FactoryGirl.build(:task) }

        it 'is not valid without a title' do 
          task.title = nil
          expect(task).not_to be_valid
        end

        it 'is not valid without a task list ID' do 
          task.task_list_id = nil
          expect(task).not_to be_valid
        end
      end

      describe 'default behavior' do 
        let(:task) { FactoryGirl.build(:task, status: nil, priority: nil) }

        it 'sets status and priority' do 
          task.save
          expect([task.status, task.priority]).to eql ['New', 'Normal']
        end

        it 'corrects invalid status and priority' do 
          task.status, task.priority = 'foo', 'bar'; task.save
          expect([task.status, task.priority]).to eql ['New', 'Normal']
        end

        it 'doesn\'t change valid status and priority' do 
          task.status, task.priority = 'Blocking', 'Low'; task.save
          expect([task.status, task.priority]).to eql ['Blocking', 'Low']
        end

        it 'sets owner and owner ID' do 
          task.save
          expect([task.owner, task.owner_id]).to eql [task.task_list.user, task.task_list.user_id]
        end

        it 'leaves backlog false' do 
          task.save
          expect(task.backlog).to be_falsey
        end
      end
    end

    describe '::complete scope' do 
      before(:each) do 
        FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks)
      end

      it 'includes all the complete tasks' do 
        expect(Task.complete).to eql Task.where(status: 'Complete')
      end

      it 'doesn\'t include the incomplete tasks' do 
        Task.where(status: 'Complete').invert.each {|t| expect(Task.complete).not_to include(t) }
      end
    end

    describe '::incomplete scope' do 
      before(:each) do
        FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks)
      end

      it 'includes all the incomplete tasks' do 
        expect(Task.incomplete).to eql Task.exclude(status: 'Complete')
      end

      it 'doesn\'t include complete tasks' do 
        Task.where(status: 'Complete').each {|t| expect(Task.incomplete).not_to include(t) }
      end
    end
  end

  describe 'instance methods' do 
    let(:task_list) { FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks) }
    let(:complete_task) { Task.where(task_list_id: task_list.id, status: 'Complete').first }

    describe '#destroy' do 
      it 'removes the task from the database' do 
        task = complete_task
        expect{ task.destroy }.to change(Task, :count).by(-1)
      end
    end

    describe '#owner' do 
      it 'is equivalent to #user' do 
        expect(task.owner).to eql task.user
      end
    end

    describe '#to_hash' do 
      let(:hash) {
        {
          id: task.id,
          task_list_id: task.task_list_id,
          owner_id: task.owner_id,
          position: task.position,
          title: task.title,
          priority: task.priority,
          status: task.status,
          created_at: task.created_at
        }
      }

      it 'returns a hash of its values' do 
        task.update(position: 3)
        expect(task.to_hash).to eql(hash)
      end

      it 'doesn\'t include blank or nil values' do 
        expect(task.to_hash).not_to have_key(:description)
      end
    end

    describe '#to_h' do 
      it 'is the same as #to_hash' do 
        expect(task.to_h).to eql(task.to_hash)
      end
    end

    describe '#to_json' do 
      it 'converts itself to hash form first' do 
        expect(task.to_json).to eql task.to_hash.to_json
      end
    end

    describe '#update' do 
      context 'with valid attributes' do 
        let(:attributes) { { deadline: (@time = Time.now.utc) } }

        it 'updates the task' do 
          complete_task.update(attributes)
          expect(complete_task.deadline).to eql @time
        end

        it 'doesn\'t change other attributes' do 
          expect(complete_task.status).to eql 'Complete'
        end
      end

      context 'without valid attributes' do 

        # IMPORTANT: The syntax of the following example is necessary for it to
        #            work. Using the :change matcher does not work. Likewise, in
        #            a bizarre turn of events, @complete_task IS updated, while
        #            the task persisted in the database with that ID is not.

        it 'doesn\'t change the attribute' do
          complete_task.update(task_list_id: nil) rescue Sequel::ValidationFailed
          expect(Task[complete_task.id].task_list_id).not_to be nil
        end

        it 'raises Sequel::ValidationFailed' do 
          expect{ complete_task.update(task_list_id: nil) }.to raise_error(Sequel::ValidationFailed)
        end
      end
    end

    describe '#user' do 
      it 'returns a User object' do 
        expect(task.user).to be_a(User)
      end

      it 'returns the user who owns the task list containing the task' do 
        expect(task.user).to eql task.task_list.user
      end
    end
  end

  describe 'associations' do 
    let(:list) { FactoryGirl.create(:task_list_with_tasks) }

    it 'is destroyed with its parent list' do 
      task = list.tasks.first; list.destroy
      expect(Task[task.id]).to be nil
    end
  end

  describe 'positioning' do 
    let(:user) { FactoryGirl.create(:user_with_task_lists) }

    context 'on create' do 
      it 'is instantiated at position 1' do 
        new_task = FactoryGirl.create(:task, task_list_id: user.default_task_list.id)
        expect(new_task.position).to eql 1
      end

      it 'changes the position of the other tasks' do 
        new_task = FactoryGirl.create(:task, task_list_id: user.default_task_list.id)
        positions = (user.tasks - [new_task]).map {|t| t.position }

        # Expected outcome is [n, ..., 3, 2] because earlier tasks have 
        # higher positions.

        expect(positions).to eql((2..user.tasks.length).to_a.reverse)
      end
    end
  end
end