require 'spec_helper'

describe Canto do 
  context 'TaskController' do 
    describe 'task indexing functions' do 
      describe 'CREATE method' do 
        context 'index not explicitly set' do           before(:all) do 
            Task.create!(title: 'My task 1', index: 1)
            Task.create!(title: 'My task 2', index: 2)
          end

          after(:all) do 
            Task.all.destroy
          end

          it 'sets new task\'s index to 1 by default' do 
            task = Task.create!(title: "My new task")
            expect(task.index).to eql 1
          end

          it 'increases index of all the other tasks by 1'
            expect(Task.find(1).index).to eql 2
            expect(Task.find(2).index).to eql 3
          end
        end # 'index not explicitly set'
      end # CREATE method
    end # task indexing functions
  end # context 'TaskController'
end # Canto
