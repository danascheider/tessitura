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

      it_behaves_like 'a filter' do 
        let(:included_tasks) { Task.where(priority: 'high') }
        let(:excluded_tasks) { [Task.where.not(priority: 'high')] }
      end
    end

    context 'with simple time conditions' do 
      let(:conditions) { { deadline: { on: { year: 2014, month: 9, day: 3 }}}}

      it_behaves_like 'a filter' do 
        let(:included_tasks) { Task.where(deadline: Time.utc(2014, 9, 3)) }
        let(:excluded_tasks) { Task.where.not(deadline: Time.utc(2014, 9, 3)) }
      end
    end

    context 'with one-sided :before interval' do 
      let(:conditions) { { deadline: { before: { year: 2014, month: 9, day: 3 } } } }

      it_behaves_like 'a filter' do 
        let(:included_tasks) { Task.where(['deadline < ?', Time.utc(2014,9,3)]) }
        let(:excluded_tasks) { Task.where.not(['deadline < ?', Time.utc(2014,9,3)]) }
      end
    end

    context 'with one-sided :after interval' do 
      let(:conditions) { { deadline: { after: { year: 2014, month: 9, day: 2 } } } }

      it_behaves_like 'a filter' do 
        let(:included_tasks) { Task.where(['deadline > ?', Time.utc(2014,9,2)]) }
        let(:excluded_tasks) { Task.where.not(['deadline > ?', Time.utc(2014,9,2)]) }
      end
    end

    context 'with two-sided time interval' do 
      let(:conditions) { { deadline: { after: { year: 2014, month: 9, day: 2 }, before: { year: 2014, month: 9, day: 5 } } } }

      it_behaves_like 'a filter' do 
        let(:included_tasks) { Task.where(deadline: [Time.utc(2014,9,3), Time.utc(2014,9,4)]) }
        let(:excluded_tasks) { Task.where.not(deadline: [Time.utc(2014,9,3), Time.utc(2014,9,4)]) }
      end
    end
  end
end