require 'spec_helper'

describe Task do 
  describe 'attributes' do 
    it { should respond_to(:title) }
    it { should respond_to(:status) }
    it { should respond_to(:position) }
    it { should respond_to(:deadline) }
    it { should respond_to(:description) }
    it { should respond_to(:priority) }
  end

  describe 'general methods' do 
    it { should respond_to(:complete?) }
    it { should respond_to(:incomplete?) }
    it { should respond_to(:to_hash) } # to integrate with Sinatra-Backbone
    it { should respond_to(:user) }
  end

  describe 'acts_as_list methods' do 
    it { should respond_to(:insert_at) }
    it { should respond_to(:move_lower) }
    it { should respond_to(:move_higher) }
    it { should respond_to(:move_to_bottom) }
    it { should respond_to(:move_to_top) }
    it { should respond_to(:remove_from_list) }
    it { should respond_to(:increment_position) }
    it { should respond_to(:decrement_position) }
    it { should respond_to(:set_list_position) }
    it { should respond_to(:first?) }
    it { should respond_to(:last?) }
    it { should respond_to(:in_list?) }
    it { should respond_to(:not_in_list?) }
    it { should respond_to(:default_position?) }
    it { should respond_to(:higher_item) }
    it { should respond_to(:lower_item) }
    it { should respond_to(:higher_items) }
    it { should respond_to(:lower_items) }
  end

  describe 'public methods' do 
    before(:each) do 
      3.times { FactoryGirl.create(:task) }
      2.times { FactoryGirl.create(:complete_task) }
    end

    describe 'self.first_complete' do 
      it 'returns the ID of the first complete task' do 
        expect(Task.first_complete).to eql 4
      end
    end

    describe 'complete?' do 
      it 'returns true when a task is complete' do 
        expect(Task.find(5).complete?).to be true
      end

      it 'returns false when a task is incomplete' do 
        expect(Task.find(1).complete?).not_to be true
      end
    end

    describe 'incomplete?' do 
      it 'returns true when a task is incomplete' do 
        expect(Task.find(1).incomplete?).to be true
      end

      it 'returns false when a task is complete' do 
        expect(Task.find(5).incomplete?).not_to be true
      end
    end
  end

  describe 'validations' do 
    before(:each) do 
      @list = FactoryGirl.create(:task_list_with_tasks)
      @task = Task.new(title: 'Foo', status: 'new', priority: 'high', task_list_id: @list.id)
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
    before(:each) do 
      @list = FactoryGirl.create(:task_list_with_tasks)
      @task = FactoryGirl.create(:task, title: "New task", task_list_id: @list.id)
    end

    it 'instantiates at position 1' do 
      expect(@task.position).to eql 1
    end

    it 'sets status to \'new\'' do
      expect(@task.status).to eql 'new'
    end

    it 'sets priority to \'normal\'' do 
      expect(@task.priority).to eql 'normal'
    end
  end

  describe 'associations' do 
    it 'is destroyed with its parent list' do 
      
    end
  end
end