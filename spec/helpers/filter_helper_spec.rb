require 'spec_helper'

describe Canto::FilterHelper do 
  include Canto::FilterHelper

  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  before(:each) do 
    @list, @task = user.task_lists.first, user.task_lists.first.tasks.first
    @task.update!(priority: 'high', deadline: Date.new(2014,8,27))
    @hash = {user: @list.owner.id, resource: 'tasks', filters: {'priority' => 'high'}}
  end

  describe '::filter_resources' do 
    before(:each) do 
      allow(Canto::FilterHelper::TaskFilter).to receive(:new).and_return(filter = double('task_filter').as_null_object)
      allow(filter).to receive(:to_a).and_return(arr = double('array'))
      allow(arr).to receive(:map).and_return [@task.to_hash]
    end

    it 'creates a TaskFilter' do 
      filter_resources(@hash)
      expect(Canto::FilterHelper::TaskFilter).to have_received(:new)
    end

    it 'returns relevant resources as JSON' do 
      expect(filter_resources(@hash)).to eql [@task.to_hash].to_json
    end
  end

  describe Canto::FilterHelper::TaskFilter do 
    describe '#filter' do 
      let(:filter) { Canto::FilterHelper::TaskFilter.new(conditions, @list.owner_id) }

      context 'with simple categorical conditions' do 
        let(:conditions) { { priority: 'high' } }

        it 'returns high-priority task' do 
          expect(filter.filter.to_a).to eql [@task]
        end

        it 'returns an ActiveRecord relation' do 
          expect(filter.filter).to be_an(ActiveRecord::Relation)
        end
      end

      context 'with simple time conditions' do 
        let(:conditions) { { deadline: Date.new(2014,8,27) } }

        it 'returns the task with the given deadline' do 
          expect(filter.filter.to_a).to eql [@task]
        end

        it 'returns an ActiveRecord relation' do 
          expect(filter.filter).to be_an(ActiveRecord::Relation)
        end
      end
    end
  end
end