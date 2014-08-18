require 'spec_helper'

describe Canto::FilterHelper do 
  include Canto::FilterHelper

  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  before(:each) do 
    @list, @task = user.task_lists.first, user.task_lists.first.tasks.first
    @task.update!(priority: 'high', deadline: Time.utc(2014,8,27))
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
      context 'with simple categorical conditions' do 
        let(:conditions) { { priority: 'high' } }
        let(:filter) { Canto::FilterHelper::TaskFilter.new(conditions, @list.owner_id) }

        it 'returns high-priority task' do 
          expect(filter.filter.to_a).to eql [@task]
        end

        it 'returns an ActiveRecord relation' do 
          expect(filter.filter).to be_an(ActiveRecord::Relation)
        end
      end

      context 'with simple time conditions' do 
        let(:conditions) { { deadline: { on: { year: 2014, month: 8, day: 27 } } } }
        let(:filter) { Canto::FilterHelper::TaskFilter.new(conditions, @list.owner_id) }

        it 'returns the task with the given deadline' do 
          expect(filter.filter.to_a).to eql [@task]
        end

        it 'returns an ActiveRecord relation' do 
          expect(filter.filter).to be_an(ActiveRecord::Relation)
        end
      end

      context 'with "before" time range conditions' do 
        let(:tasks) { (1..3).each {|i| FactoryGirl.create(:task, deadline: Date.new(2014,9,i)) } }
        let(:conditions) { { deadline: { before: { year: 2014, month: 9, day: 2 } } } }
        let(:filter) { Canto::FilterHelper::TaskFilter.new(conditions, @list.owner_id) }

        it 'includes the tasks with earlier deadlines' do 
          expect(filter.filter.to_a).to include(tasks.to_a[0])
        end

        it 'excludes the tasks with equal or later deadlines' do 
          expect(filter.filter.to_a).not_to include(tasks.to_a[1..2])
        end
      end
    end
  end
end