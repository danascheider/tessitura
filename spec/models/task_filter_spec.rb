require 'spec_helper'

describe TaskFilter do 
  let(:task_list) { FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks) }

  before(:each) do 
    @list, i = task_list, 1
    @list.tasks.each {|task, n| task.update!(deadline: Time.utc(2014, 9, i)); i+= 1 }
    @task = Task.where(deadline: Time.utc(2014,9,3)).first
    @task.update!(priority: 'high')
  end

  describe '#filter' do 
    context 'with simple categorical conditions' do 
      let(:conditions) { { priority: 'high' } }
      let(:filter) { TaskFilter.new(conditions, @list.owner_id) }

      it 'returns an ActiveRecord::Relation' do 
        expect(filter.filter).to be_an(ActiveRecord::Relation)
      end

      it 'returns the high-priority task' do 
        expect(filter.filter.to_a).to eql [@task]
      end
    end

    context 'with simple time conditions' do 
      let(:conditions) { { deadline: { on: { year: 2014, month: 9, day: 3 }}}}
      let(:filter) { TaskFilter.new(conditions, @list.owner_id) }

      it 'returns an ActiveRecord::Relation' do 
        expect(filter.filter).to be_an(ActiveRecord::Relation)
      end

      it 'returns the task with the given deadline' do 
        expect(filter.filter.to_a).to eql [@task]
      end
    end

    context 'with one-sided :before interval' do 
      let(:conditions) { { deadline: { before: { year: 2014, month: 9, day: 3 } } } }
      let(:filter) { TaskFilter.new(conditions, @list.owner_id) }
      let(:filtered_tasks) { filter.filter }

      it 'returns an ActiveRecord::Relation' do 
        expect(filtered_tasks).to be_an(ActiveRecord::Relation)
      end

      it 'returns the tasks with earlier deadlines' do 
        expect(filtered_tasks.to_a).to eql Task.where('deadline < ?', Time.utc(2014,9,3)).to_a
      end

      it 'excludes the tasks with equal or later deadlines' do 
        excluded = Task.where('deadline > ?', Time.utc(2014,9,2))
        expect(filtered_tasks.to_a & excluded.to_a).to eql []
      end

      it 'excludes tasks with no deadline' do 
        @list.tasks.create(title: 'Make dentist appointment')
        expect(filtered_tasks.to_a).not_to include(Task.find_by(title: 'Make dentist appointment'))
      end
    end

    context 'with one-sided :after interval' do 
      let(:conditions) { { deadline: { after: { year: 2014, month: 9, day: 2 } } } }
      let(:filter) { TaskFilter.new(conditions, @list.owner_id) }
      let(:filtered_tasks) { filter.filter }

      it 'returns an ActiveRecord::Relation' do 
        expect(filtered_tasks).to be_an(ActiveRecord::Relation)
      end

      it 'returns the tasks with later deadlines' do 
        expect(filtered_tasks.to_a).to eql Task.where('deadline > ?', Time.utc(2014,9,2)).to_a
      end

      it 'excludes tasks with equal or earlier deadlines' do 
        excluded = Task.where('deadline < ?', Time.utc(2014,9,3)).to_a
        expect(filtered_tasks.to_a & excluded).to eql []
      end
    end
  end
end