require 'spec_helper'

describe Canto::TaskController do 
  include Canto::TaskController
  include Canto::ErrorHandling

  describe 'create_task method' do 
    before(:each) do 
      5.times {|n| FactoryGirl.create(:task, index: n + 1)}
    end
    
    context 'normal creation' do 
      before(:each) do 
        create_task(title: "New Task")
      end

      it 'creates a new task' do 
        expect(Task.last.title).to eql "New Task"
      end
    end

    context 'task created with completion status true' do 
      before(:each) do 
        Task.find([4,5]).each {|task| task.update!(complete: true)}
      end

      it 'creates the task as the first complete task' do 
        create_task(title: "New Task", complete: true)
        expect(Task.last.index).to eql 4
      end
    end
  end

  describe 'update_task method' do 
    before(:each) do 
      5.times {|n| FactoryGirl.create(:task, index: n + 1)}
    end

    context 'general update' do 
      before(:each) do 
        update_task(3, title: 'Task the Third')
      end

      it 'changes the updated attributes' do 
        expect(Task.find(3).title).to eql 'Task the Third'
      end
    end

    context 'toggle complete' do 
      before(:each) do 
        Task.find([4,5]).each {|task| task.update!(complete: true)}
      end

      it 'moves a completed task to the end' do 
        update_task(2, complete: true)
        expect(Task.find(2).index).to eql Task.max_index
      end

      it 'moves a task to the top when changed to incomplete' do 
        update_task(4, complete: false)
        expect(Task.find(4).index).to eql 1
      end
    end

    describe 'delete_task method' do 
      before(:each) do 
        delete_task(4)
        TaskIndexer.refresh_index_array
      end

      it 'deletes the task' do 
        expect(Task.pluck(:id)).not_to include 4
      end
    end
  end

  describe 'get_task method' do 
    before(:each) do 
      5.times {|n| FactoryGirl.create(:task, index: n+1)}
    end
    
    it 'returns the task as a JSON object' do 
      expect(get_task(3)).to eql Task.find(3).to_json
    end
  end
end # Canto::TaskController
