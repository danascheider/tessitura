require 'spec_helper'

describe TaskIndexer do 

  describe 'dup and gap methods' do 
    describe 'dup method' do 
      before(:each) do 
        allow(Task).to receive(:count) {5}
      end

      it 'returns an integer if there is a duplicate index' do
        TaskIndexer.refresh_index_array [1, 2, 3, 3, 4]
        expect(TaskIndexer.dup).to be_an Integer
      end

      it 'returns nil if there is no duplicate index' do 
        TaskIndexer.refresh_index_array [1, 2, 3]
        expect(TaskIndexer.dup).to be nil
      end
    end

    describe 'gap method' do 
      before(:each) do 
        allow(Task).to receive(:count) {3}
      end

      it 'returns an integer if there is a missing index' do 
        TaskIndexer.refresh_index_array [1, 3, 4]
        expect(TaskIndexer.gap).to be_an Integer 
      end

      it 'returns nil if there is no missing index' do 
        TaskIndexer.refresh_index_array [1, 2, 3]
        expect(TaskIndexer.gap).to eql nil
      end
    end 

    context 'no tasks' do 
      before(:each) do 
        allow(Task).to receive(:count) {0}
      end

      it 'does not identify a duplicate' do 
        expect(TaskIndexer.dup).to be nil
      end

      it 'does not identify a gap' do 
        expect(TaskIndexer.gap).to eql nil
      end
    end

    context 'two or more tasks' do 
      before(:each) do 
        allow(Task).to receive(:count) {2}
      end

      it 'identifies a duplicate' do 
        TaskIndexer.refresh_index_array [1, 1]
        expect(TaskIndexer.dup).to eql 1
      end

      it 'identifies a gap' do 
        TaskIndexer.refresh_index_array [1, 3]
        expect(TaskIndexer.gap).to eql 2
      end
    end
  end

  describe 'task indexing functionality' do 
    before(:each) do 
      6.times {|n| FactoryGirl.create(:task, index: n+1)}
    end

    context 'when a new task is created' do 
      context 'with no index explicitly set' do 
        it 'increases the other tasks\' indices' do 
          FactoryGirl.create(:task)
          TaskIndexer.update_indices
          expect(Task.pluck(:index).sort).to eql [1, 2, 3, 4, 5, 6, 7]
        end
      end

      context 'with the index explicitly set' do 
        before(:each) do 
          FactoryGirl.create(:task, title: "My New Task", index: 2)
          TaskIndexer.update_indices
        end

        it 'assigns the given index' do 
          expect(Task.last.index).to eql 2
        end

        it 'updates the indices accordingly' do 
          expect(Task.pluck(:index).sort).to eql [1, 2, 3, 4, 5, 6, 7]
        end
      end
    end

    context 'when a task is updated' do 
      context 'with an index specified' do 
        before(:each) do 
          Task.find(2).update!(index: 4)
          TaskIndexer.update_indices
        end

        it 'changes the other tasks\' indices' do 
          indices = Task.find([3, 4]).map {|task| task.index }
          expect(indices).to eql [2, 3]
        end
      end
    end

    context 'when an existing task is deleted' do 
      before(:each) do 
        Task.find(4).destroy
        TaskIndexer.update_indices
      end
      
      it 'decreases the index of the other tasks' do 
        expect(Task.pluck(:index).sort).to eql [1, 2, 3, 4, 5]
      end
    end
  end
end