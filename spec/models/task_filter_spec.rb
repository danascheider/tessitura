require 'spec_helper'

describe TaskFilter do 
  let(:task_list) { FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks) }
  let(:task) { task_list.tasks.first } 

  before(:each) do 
    @list, @task = task_list, task
    @task.update!(priority: 'high')
  end

  describe '#filter' do 
    context 'with simple categorical conditions' do 
      let(:conditions) { { priority: 'high' } }
      let(:filter) { TaskFilter.new(conditions, task_list.owner_id) }

      it 'returns an ActiveRecord::Relation' do 
        expect(filter.filter).to be_an(ActiveRecord::Relation)
      end

      it 'returns the high-priority task' do 
        expect(filter.filter.to_a).to eql [@task]
      end
    end
  end
end