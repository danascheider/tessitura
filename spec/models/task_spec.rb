require 'spec_helper'

describe Task do 
  let(:task) { FactoryGirl.create(:task) }

  describe 'attributes' do 
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:status) }
    it { is_expected.to respond_to(:position) }
    it { is_expected.to respond_to(:deadline) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:priority) }
  end

  describe 'public instance methods' do 
    it { is_expected.to respond_to(:complete?) }
    it { is_expected.to respond_to(:incomplete?) }
    it { is_expected.to respond_to(:to_hash) } # to integrate with Sinatra-Backbone
    it { is_expected.to respond_to(:user) }
    it { is_expected.to respond_to(:owner_id) }
    it { is_expected.to respond_to(:owner) }
  end

  describe 'acts_as_list methods' do 
    it { is_expected.to respond_to(:insert_at) }
    it { is_expected.to respond_to(:move_lower) }
    it { is_expected.to respond_to(:move_higher) }
    it { is_expected.to respond_to(:move_to_bottom) }
    it { is_expected.to respond_to(:move_to_top) }
    it { is_expected.to respond_to(:remove_from_list) }
    it { is_expected.to respond_to(:increment_position) }
    it { is_expected.to respond_to(:decrement_position) }
    it { is_expected.to respond_to(:set_list_position) }
    it { is_expected.to respond_to(:first?) }
    it { is_expected.to respond_to(:last?) }
    it { is_expected.to respond_to(:in_list?) }
    it { is_expected.to respond_to(:not_in_list?) }
    it { is_expected.to respond_to(:default_position?) }
    it { is_expected.to respond_to(:higher_item) }
    it { is_expected.to respond_to(:lower_item) }
    it { is_expected.to respond_to(:higher_items) }
    it { is_expected.to respond_to(:lower_items) }
  end

  describe 'public methods' do 
    let(:task_list) { FactoryGirl.create(:task_list_with_tasks, tasks_count: 5) }

    before(:each) do 
      task_list.tasks.last(2).each {|task| task.update!(status: 'complete') }
      @complete_task = task_list.tasks.complete.order(:position).first
    end

    describe '::first_complete' do 
      it 'returns the  first complete task' do 
        expect(Task.first_complete).to eql @complete_task
      end
    end

    describe '#complete?' do 
      it 'returns true when a task is complete' do 
        expect(@complete_task.complete?).to be_truthy
      end

      it 'returns false when a task is incomplete' do 
        expect(task.complete?).to be_falsey
      end
    end

    describe '#incomplete?' do 
      it 'returns true when a task is incomplete' do 
        expect(task.incomplete?).to be_truthy
      end

      it 'returns false when a task is complete' do 
        expect(@complete_task.incomplete?).to be_falsey
      end
    end

    describe '#user' do 
      it 'returns the user who owns the task list containing the task' do 
        expect(task.user).to eql task.task_list.user
      end
    end

    describe '#owner' do 
      it 'returns a user model' do 
        expect(task.owner).to be_a(User)
      end

      it 'is equivalent to #user' do 
        expect(task.owner).to eql task.user
      end
    end

    describe '#owner_id' do
      it 'returns its user\'s ID' do 
        expect(task.owner_id).to eql task.user.id
      end
    end
  end

  describe 'validations' do 
    before(:each) do 
      @task = FactoryGirl.build(:task, title: 'Foo', status: 'new', priority: 'high')
    end

    context 'when valid' do 
      it 'should be valid' do 
        expect(@task).to be_valid
      end
    end

    context 'pertaining to title' do 
      it 'is invalid without a title' do 
        @task.title = nil
        expect(@task).not_to be_valid
      end
    end

    context 'pertaining to status' do 
      it 'doesn\'t permit invalid status' do 
        @task.status = "Bar"
        expect(@task).not_to be_valid
      end
    end

    context 'pertaining to priority' do 
      it 'doesn\'t permit invalid priorities' do 
        @task.priority = 'Bar'
        expect(@task).not_to be_valid
      end
    end

    context 'pertaining to associations' do 
      it 'can\'t be saved without a task list' do 
        @task.task_list_id = nil 
        expect(@task).not_to be_valid
      end
    end
  end

  describe 'default behavior' do 
    let(:list) { FactoryGirl.create(:task_list_with_tasks, tasks_count: 5) }
    let(:new_task) { list.tasks.create(title: 'New Task') }

    it 'sets status to \'new\'' do
      expect(new_task.status).to eql 'new'
    end

    it 'sets priority to \'normal\'' do 
      expect(new_task.priority).to eql 'normal'
    end

    context 'when status is set to complete' do 
      it 'instantiates as the first complete task' do 
        pending 'Figure out list issues'
        expect(list.tasks.create(title: 'Foo', status: 'complete').position).to eql 5
      end
    end

    context 'when status is not set to complete' do 
      it 'instantiates at position 1' do 
        expect(new_task.position).to eql 1
      end
    end
  end

  describe 'associations' do 
    let(:list) { FactoryGirl.create(:task_list_with_tasks) }

    it 'is destroyed with its parent list' do 
      @task = list.tasks.first
      list.destroy!
      expect(get_resource(Task, @task.id)).to eql nil
    end
  end
end