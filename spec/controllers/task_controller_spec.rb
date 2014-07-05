require 'spec_helper'

describe Canto::TaskController do 
  include Canto::TaskController
  include Canto::ErrorHandling

  context 'task indexing functions' do 

    context 'CREATE method' do 
      context 'index not explicitly set' do           
        before(:each) do 
          Task.create!(title: 'My task 1', index: 1)
          create_task(title: "My new task")
          @task = Task.last
        end

        it 'sets new task\'s index to 1 by default' do 
          expect(@task.index).to eql 1
        end

        it 'increases index of other tasks by 1' do
          expect(find_task(1).index).to eql 2
        end
      end # 'index not explicitly set'

      context 'index explicitly set' do 
        before(:each) do 
          for i in 1..4
            Task.create!(title: "My task #{i}", index: i)
          end
          create_task(title: "My new task", index: 3)
          @task = Task.last
        end

        it 'sets the task\'s index to the one specified' do 
          expect(@task.index).to eql 3
        end

        it 'increases index of 3rd and 4th tasks by 1' do 
          expect(Task.where.not(title: "My new task").pluck(:index)).to eql [1, 2, 4, 5]
        end
      end # index explicitly set

      context 'invalid index' do 
        before(:each) do 
          for i in 1..3
            Task.create!(title: "My task #{i}", index: i)
          end
        end

        it 'sets index to highest' do 
          create_task(title: "My new task", index: 6)
          expect(Task.last.index).to eql 4
        end

        it 'sets the index to 1' do 
          create_task(title: "My new task", index: 0)
          expect(Task.last.index).to eql 1
        end
      end # invalid index
    end # CREATE method

    context 'UPDATE method' do 
      before(:each) do 
        for i in 1..4
          Task.create!(title: "My task #{i}", index: i)
        end
      end

      context 'with index set explicitly' do 
        context 'task moved higher on the list' do 
          it 'changes the task index' do 
            update_task(4, index: 2)
            expect(Task.find(4).index).to eql 2
          end

          it 'moves the other tasks down' do 
            update_task(4, index: 2)
            indices = Task.find([2,3]).map {|task| task.index }
            expect(indices).to eql [3, 4]
          end
        end # context task moved higher on the list

        context 'task moved down on the list' do 
          it 'changes the task index' do 
            update_task(1, index: 3)
            expect(Task.find(1).index).to eql 3 
          end

          it 'moves the other tasks up' do 
            update_task(1, index: 3)
            indices = Task.find([2,3]).map {|task| task.index }
            expect(indices).to eql [1,2]
          end
        end # context task moved down on the list

        context 'toggle complete' do 
          it 'sets the given index when task marked complete' do 
            update_task(1, { complete: true, index: 2 })
            expect(Task.find(1).index).to eql 2
          end

          it 'sets the given index when task marked incomplete' do 
            Task.find(2).update!(complete: true)
            update_task(2, complete: false, index: 3)
            expect(Task.find(2).index).to eql 3
          end
        end # context toggle complete

        context 'invalid index' do 
          it 'sets the index to the max' do 
            update_task(2, index: 6)
            expect(Task.find(2).index).to eql 4
          end

          it 'sets the index to 1' do 
            update_task(3, index: 0)
            expect(Task.find(3).index).to eql 1
          end
        end # context invalid index
      end # context with index explicitly set

      context 'without explicit index' do 
        it 'doesn\'t change the index unnecessarily' do 
          update_task(3, title: 'Foo bar')
          expect(Task.find(3).index).to eql 3
        end

        context 'toggle complete' do 
          it 'moves complete task to the end of the list' do 
            update_task(2, complete: true)
            expect(Task.find(2).index).to eql 4
          end

          it 'moves incomplete task to the top of the list' do 
            Task.find(4).update!(complete: true)
            update_task(4, complete: false)
            expect(Task.find(4).index).to eql 4
          end
        end # context toggle complete
      end # context without explicit index
    end # UPDATE method
  end # task indexing functions
end # Canto::TaskController
