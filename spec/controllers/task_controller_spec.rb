require 'spec_helper'

describe Canto do 
  context 'TaskController' do 
    describe 'task indexing functions' do 

      describe 'CREATE method' do 
        context 'index not explicitly set' do           
          before(:all) do 
            Task.create!(title: 'My task 1', index: 1)
          end

          after(:all) do 
            Task.all.each {|task| task.destroy }
          end

          it 'sets new task\'s index to 1 by default' do 
            task = Task.create!(title: "My new task")
            expect(task.index).to eql 1
          end

          it 'increases index of other tasks by 1' do
            expect(Task.find(1).index).to eql 2
          end
        end # 'index not explicitly set'

        context 'index explicitly set' do 
          before(:all) do 
            for i in 1..4
              Task.create!(title: "My task #{i}", index: i)
            end
          end

          after(:all) do 
            Task.all.each {|task| task.destroy }
          end

          it 'sets the task\'s index to the one specified' do 
            @task = Task.create!(title: "My new task", index: 3)
            expect(@task.index).to eql 3
            Task.all.to_a.each {|task| puts "#{task.to_hash}\n"}
          end

          it 'increases index of 3rd and 4th tasks by 1' do 
            expect(neg_task_scope(id: @task.id)).to eql [1, 2, 4, 5]
          end
        end # index explicitly set
      end # CREATE method
    end # task indexing functions
  end # context 'TaskController'
end # Canto
