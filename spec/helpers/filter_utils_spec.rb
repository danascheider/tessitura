require 'spec_helper'

describe Sinatra::FilterUtils do 
  include Sinatra::FilterUtils

  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  before(:each) do 
    @list, @task = user.task_lists.first, user.task_lists.first.tasks.first
    @task.update!(priority: 'high', deadline: Time.utc(2014,8,27))
    @hash = {user: @list.owner.id, filters: {'priority' => 'high'}}
  end

  describe '::filter_resources' do 
    before(:each) do 
      allow(TaskFilter).to receive(:new).and_return(filter = double('task_filter').as_null_object)
      allow(filter).to receive(:to_a).and_return(arr = double('array'))
      allow(arr).to receive(:map).and_return [@task.to_hash]
    end

    it 'creates a TaskFilter' do 
      filter_resources(@hash)
      expect(TaskFilter).to have_received(:new)
    end

    it 'returns relevant resources as JSON' do 
      expect(filter_resources(@hash)).to eql [@task.to_hash].to_json
    end
  end
end