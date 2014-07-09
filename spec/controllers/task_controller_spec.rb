require 'spec_helper'

# Some edge cases still need to be accounted for in indices:
# => If a task is created with :complete => true, it should be added
#    as the FIRST complete task
# => Need to validate uniqueness of indices as well as sequentiality

describe Canto::TaskController do 
  include Canto::TaskController
  # include Canto::TaskIndexing
  include Canto::ErrorHandling

  describe 'CREATE method' do 
    before(:each) do 
      5.times {|n| FactoryGirl.create(:task, index: n + 1)}
    end
    
    context 'normal creation' do 
      before(:each) do 
        create_task(title: "New Task")
      end

      it 'creates a new task' do 
        create_task(title: "New Task")
        expect(Task.last.title).to eql "New Task"
      end

      it 'updates the indices' do 
        expect(Task.pluck(:index).sort).to eql [1, 2, 3, 4, 5, 6]
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

  describe 'UPDATE method' do 
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

    context 'changed index' do 
      it 'updates the other indices' do 
        update_task(3, index: 5)
        puts "TASKS:"
        Task.all.each {|task| puts "#{task.to_hash}\n"}
        other_indices = Task.find([4, 5]).map {|task| task.index }
        expect(other_indices).to eql [3, 4]
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

    describe 'DELETE method' do 
      before(:each) do 
        5.times {|n| FactoryGirl.create(:task, index: n+1)}
        delete_task(4)
      end

      it 'deletes the task' do 
        expect(Task.pluck(:id)).not_to include 4
      end

      it 'updates the indices' do 
        expect(Task.find(5).index).to eql 4
      end
    end
  end

  describe 'GET method' do 
    before(:each) do 
      5.times {|n| FactoryGirl.create(:task, index: n+1)}
    end
    
    it 'returns the task as a JSON object' do 
      expect(get_task(3)).to eql Task.find(3).to_json
    end
  end
end # Canto::TaskController
