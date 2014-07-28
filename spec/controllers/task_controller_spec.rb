require 'spec_helper'

describe Canto::TaskController do 
  include Canto::TaskController
  #FIX: Is ErrorHandling actually used here?
  include Canto::ErrorHandling

  before(:each) do 
    @list = FactoryGirl.create(:task_list_with_tasks, tasks_count: 5)
    @list.tasks.first(2).each { |task| task.update(status: 'complete') }
    @task = Task.take
  end

  describe 'create_task method' do     
    context 'normal creation' do 
      it 'creates a new task' do 
        expect { create_task(title: "New Task", task_list_id: @list.id) }.to change { Task.count }.by(1)
      end
    end

    context 'when there is no task list' do 
      before(:each) do 
        # This user must (obviously) not have a task list. For that reason,
        # it can't be declared in the before block at the top
        @user = FactoryGirl.create(:user)
        create_task(title: 'Brand New Task', user_id: @user.id)
      end

      it 'creates a new task' do 
        expect(Task.last.title).to eql 'Brand New Task'
      end

      it 'creates a new list' do 
        expect(@user.task_lists.first.title).to eql 'Default List'
      end
    end

    context 'task created with completion status true' do 
      it 'creates the task as the first complete task' do 
        create_task(title: "New Task", status: 'complete', task_list_id: @list.id)
        expect(Task.last.position).to eql 4
      end
    end
  end

  describe 'update_task method' do 
    context 'general update' do 
      before(:each) do 
        update_task(@task.id, title: 'Task with a New Name')
      end

      it 'changes the updated attributes' do 
        expect(Task.find(@task.id).title).to eql 'Task with a New Name'
      end
    end

    context 'toggle complete' do 
      before(:each) do 
        @incomplete_id = @list.tasks.incomplete.take.id
        @complete_id = @list.tasks.complete.take.id
      end

      it 'moves a completed task to the end' do 
        update_task(@incomplete_id, status: 'complete')
        expect(Task.find(@incomplete_id).position).to eql Task.count
      end

      it 'moves a task to the top when changed to incomplete' do 
        update_task(@complete_id, status: 'in_progress')
        expect(Task.find(@complete_id).position).to eql 1
      end
    end
  end

  describe 'delete_task method' do 
    it 'deletes the task' do 
      expect { delete_task(Task.last.id) }.to change { Task.count }.by(-1)
    end
  end

  describe 'get_task method' do 
    it 'returns the task as a JSON object' do 
      expect(get_task(@task.id)).to eql @task.to_json
    end
  end
end # Canto::TaskController
