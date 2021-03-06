require 'spec_helper'

describe Task, tasks: true do 
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

    describe '::fresh scope' do 
      before(:each) do 
        FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks)
        Task.first.update(backlog: true)
      end

      it 'doesn\'t include complete tasks' do 
        Task.complete.each {|t| expect(Task.fresh).not_to include(t) }
      end

      it 'doesn\'t include backlogged tasks' do 
        expect(Task.fresh).not_to include(Task.first)
      end

      it 'includes other tasks' do 
        expect(Task.fresh.first).to be_a(Task)
      end

      it 'is a Sequel::Dataset' do 
        expect(Task.fresh).to be_a Sequel::Dataset
      end
    end

    describe '::stale scope' do 
      before(:each) do 
        FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks)
        Task.first.update(backlog: true)
      end

      it 'is the complement of the ::fresh scope' do 
        expect(Task.stale.all).to eql(Task.all - Task.fresh.all)
      end

      it 'is a Sequel::Dataset' do 
        expect(Task.stale).to be_a Sequel::Dataset
      end
    end
  end

  describe 'instance methods' do 
    let(:task_list) { FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks) }
    let(:complete_task) { Task.where(task_list_id: task_list.id, status: 'Complete').first }

    describe '#incomplete?' do 
      context 'when the task is incomplete' do 
        it 'returns true' do 
          expect(task.incomplete?).to be true
        end
      end

      context 'when the task is complete' do 
        it 'returns false' do 
          expect(complete_task.incomplete?).to be false
        end
      end
    end

    describe '#destroy' do 
      it 'removes the task from the database' do 
        task = complete_task
        expect{ task.destroy }.to change(Task, :count).by(-1)
      end
    end

    describe '#fresh?' do 
      context 'when true' do 
        it 'returns true' do 
          expect(FactoryGirl.create(:task).fresh?).to be true 
        end
      end

      context 'when the task is complete' do 
        it 'returns false' do 
          expect(complete_task.fresh?).to be false
        end
      end

      context 'when the task is backlogged' do 
        it 'returns false' do 
          expect(FactoryGirl.create(:task, backlog: true).fresh?).to be false 
        end
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

        it 'changes backlog to false if the task is marked complete' do 
          task.update(backlog: true)
          task.update(status: 'Complete')
          expect(task.backlog).to be nil
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
      context 'normal' do
        it 'is instantiated at position 1' do 
          new_task = FactoryGirl.create(:task, task_list_id: user.default_task_list.id)
          expect(new_task.position).to eql 1
        end

        it 'changes the position of the other tasks' do 
          new_task = FactoryGirl.create(:task, task_list_id: user.default_task_list.id)
          positions = (user.tasks - [new_task]).map(&:position).sort.reverse

          # Expected outcome is [n, ..., 3, 2] because earlier tasks have 
          # higher positions.

          expect(positions).to eql((2..user.tasks.length).to_a.reverse)
        end
      end

      context 'created complete' do 
        before(:each) do 
          user 
        end

        it 'is instantiated below the last incomplete task' do 
          pos = Task.incomplete.order(:position).last.position + 1
          new_task = FactoryGirl.create(:task, task_list_id: user.default_task_list.id, status: 'Complete')
          expect(new_task.position).to eql pos
        end
      end

      context 'created backlogged' do 
        before(:each) do 
          user
        end

        it 'is instantiated below the last incomplete, non-backlogged task' do 
          pos = Task.fresh.order(:position).last.position + 1
          new_task = FactoryGirl.create(:task, task_list_id: user.default_task_list.id, backlog: true)
          expect(new_task.position).to eql pos
        end
      end
    end

    context 'task moved up on the list' do 
      before(:each) do 
        @task = user.tasks.find {|t| t.position === 6 }
        @subset = user.tasks.select {|t| t.position >= 2 && t.position < 6 }
      end

      it 'increments the positions of tasks between old and new positions' do 
        initial_positions = @subset.map(&:position)

        @task.update({position: 2})

        changed_positions = @subset.map {|t| t.refresh.position }
        expect(changed_positions).to eql(initial_positions.map {|num| num + 1 })
      end

      it 'doesn\'t change the positions of other tasks' do 
        other_positions = (other_tasks = user.tasks - [@task] - @subset).map(&:position)
        @task.update({position: 6})
        changed_positions = other_tasks.map {|t| t.refresh.position }

        expect(changed_positions).to eql other_positions
      end
    end

    context 'task moved down on the list' do 
      before(:each) do 
        @task = user.tasks.find {|t| t.position === 2 }
        @subset = user.tasks.select {|t| t.position > 2 && t.position <= 6 }
      end

      it 'decrements the positions of tasks between old and new positions' do 
        initial_positions = @subset.map(&:position)

        @task.update({position: 6})

        changed_positions = @subset.map {|t| t.refresh.position }
        expect(changed_positions).to eql(initial_positions.map {|num| num - 1 })
      end

      it 'doesn\'t change the positions of other tasks' do 
        other_positions = (other_tasks = user.tasks - [@task] - @subset).map(&:position)
        @task.update({position: 6})
        changed_positions = other_tasks.map {|t| t.refresh.position }

        expect(changed_positions).to eql other_positions
      end
    end

    context 'task deleted' do 
      before(:each) do 
        @task = user.tasks.find {|t| t.position === 7 }
        @subset = user.tasks.select {|t| t.position > 7 }
      end

      it 'decrements the positions of tasks after the deleted one' do 
        initial = @subset.map(&:position)
        @task.destroy
        changed_positions = @subset.map {|t| t.refresh.position }
        expect(changed_positions).to eql(initial.map {|num| num - 1})
      end

      it 'doesn\'t change the positions of tasks before the deleted one' do 
        initial = (other = user.tasks - @subset - [@task]).map(&:position)
        @task.destroy
        final = other.map {|t| t.refresh.position}
        expect(final).to eql initial
      end
    end

    context 'status changed to \'Complete\'' do 
      context 'other tasks are all incomplete' do 
        before(:each) do 
          user.tasks.each {|t| t.update(status: 'New') }
          @lower = user.tasks.select {|t| t.refresh.position > 3 }
          @task = Task.find(position: 3)
        end

        it 'moves the complete task to the bottom of the list' do 
          @task.update(status: 'Complete')
          expect(@task.position).to eql user.tasks.length
        end

        it 'moves the other tasks up' do 
          expected = (@lower).map {|t| t.position - 1}
          @task.update(status: 'Complete')
          actual = @lower.map {|t| t.refresh.position }
          expect(actual).to eql(expected)
        end

        it 'honors an explicit position assignment' do 
          @task.update(status: 'Complete', position: 2)
          expect(@task.position).to eql 2
        end
      end

      context 'some other tasks are also complete' do 
        before(:each) do 
          user # has to be invoked to create FactoryGirl object
          @task = Task.find(position: 1)
        end

        it 'moves the complete task under the last incomplete task' do 
          position = Task.incomplete.where(owner_id: user.id).order(:position).last.position
          @task.update(status: 'Complete')
          expect(@task.position).to eql position
        end
      end

      context 'some other tasks are complete and some are backlogged' do 
        before(:each) do 
          user.tasks.where_not(:status, 'Complete').last(2).each {|t| t.update(backlog: true) }
          @task = Task.find(position: 1)
        end

        it 'moves the complete task under the last backlogged task' do 
          position = Task.where(backlog: true).order(:position).last.position
          @task.update(status: 'Complete')
          expect(@task.position).to eql position
        end
      end
    end

    context 'status changed from \'Complete\'' do 
      context 'without position being set explicitly' do 
        before(:each) do 
          user
          @task = Task.complete.first
          @higher = user.tasks.select {|t| t.refresh.position < @task.position }
        end

        it 'is moved to position 1' do 
          @task.update(status: 'In Progress')
          expect(@task.refresh.position).to eql 1
        end

        it 'moves the other tasks down' do 
          expected = @higher.map {|t| t.position + 1}
          @task.update(status: 'In Progress')
          actual = @higher.map {|t| t.refresh.position }
          expect(actual).to eql(expected)
        end
      end

      context 'position set explicitly' do 
        before(:each) do 
          user
          @task = Task.complete.last
        end

        it 'honors the explicit position assignment' do 
          @task.update(status: 'Blocking', position: 10)
          expect(@task.refresh.position).to eql 10
        end
      end
    end

    context 'backlog set to true' do 
      context 'tasks are all incomplete and not backlogged' do 
        before(:each) do 
          user.tasks.each {|t| t.update(status: 'New', backlog: nil) }
          @lower = user.tasks.select {|t| t.refresh.position > 3 }
          @task = Task.find(position: 3)
        end

        it 'moves the backlogged task to the bottom of the list' do 
          @task.update(backlog: true)
          expect(@task.position).to eql user.tasks.length
        end

        it 'moves the other tasks up' do 
          expected = (@lower).map {|t| t.position - 1}
          @task.update(status: 'Complete')
          actual = @lower.map {|t| t.refresh.position }
          expect(actual).to eql(expected)
        end

        it 'honors an explicit position assignment' do 
          @task.update(status: 'Complete', position: 2)
          expect(@task.position).to eql 2
        end
      end

      context 'some other tasks are also complete' do 
        before(:each) do 
          user # has to be invoked to create FactoryGirl object
          @task = Task.find(position: 1)
        end

        it 'moves the complete task under the last incomplete task' do 
          position = Task.incomplete.where(owner_id: user.id).order(:position).last.position
          @task.update(status: 'Complete')
          expect(@task.position).to eql position
        end
      end

      context 'some other tasks are complete and some are backlogged' do 
        before(:each) do 
          user.tasks.where_not(:status, 'Complete').last(2).each {|t| t.update(backlog: true) }
          @task = Task.find(position: 1)
        end

        it 'moves the complete task under the last backlogged task' do 
          position = Task.where(backlog: true).order(:position).last.position
          @task.update(status: 'Complete')
          expect(@task.position).to eql position
        end
      end
    end

    context 'status changed from \'Complete\'' do 
      context 'without position being set explicitly' do 
        before(:each) do 
          user
          @task = Task.complete.first
          @higher = user.tasks.select {|t| t.refresh.position < @task.position }
        end

        it 'is moved to position 1' do 
          @task.update(status: 'In Progress')
          expect(@task.refresh.position).to eql 1
        end

        it 'moves the other tasks down' do 
          expected = @higher.map {|t| t.position + 1}
          @task.update(status: 'In Progress')
          actual = @higher.map {|t| t.refresh.position }
          expect(actual).to eql(expected)
        end
      end

      context 'with position set explicitly' do 
        before(:each) do 
          user 
          @task = Task.complete.first
        end

        it 'honors the requested position' do 
          @task.update(status: 'Blocking', position: 2)
          expect(@task.refresh.position).to eql 2
        end
      end
    end

    context 'backlog set to true' do 
      context 'tasks are all incomplete and not backlogged' do 
        before(:each) do 
          user.tasks.each {|t| t.update(status: 'New', backlog: nil) }
          @lower = user.tasks.select {|t| t.refresh.position > 3 }
          @task = Task.find(position: 3)
        end

        it 'moves the backlogged task to the bottom of the list' do 
          @task.update(backlog: true)
          expect(@task.position).to eql user.tasks.length
        end

        it 'moves the other tasks up' do 
          initial = (@lower).map(&:position)
          @task.update(backlog: true)
          final = @lower.map {|t| t.refresh.position }
          expect(final).to eql(initial.map {|num| num - 1 })
        end

        it 'honors an explicit position assignment' do 
          @task.update(backlog: true, position: 2)
          expect(@task.position).to eql 2
        end
      end

      context 'there are other backlogged tasks' do 
        before(:each) do 
          user.tasks.scope(:status, 'Complete').each {|t| t.update(status: 'New', backlog: true) }
          @task = Task.find(position: 1)
        end

        it 'moves the task below the last non-backlogged task' do 
          position = Task.exclude(backlog: true).order(:position).last.position
          @task.update(backlog: true)
          expect(@task.position).to eql position
        end
      end

      context 'there are complete and backlogged tasks' do 
        before(:each) do 
          user # instantiate FactoryGirl object
          Task.incomplete.order(:position).last(2).each {|t| t.update(backlog: true) }
          @task = Task.find(position: 1)
        end

        it 'moves the task below the last non-backlogged task' do 
          position = Task.fresh.order(:position).last.position 
          @task.update(backlog: true)
          expect(@task.position).to eql position
        end
      end
    end
  end
end