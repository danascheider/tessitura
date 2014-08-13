require 'spec_helper'

describe Canto::FilterHelper do 
  include Canto::FilterHelper

  describe '::get_filtered' do 
    let(:user) { FactoryGirl.create(:user_with_task_lists) }

    before(:each) do 
      @list, @task = user.task_lists.first, user.task_lists.first.tasks.first
      @task.update!(priority: 'high')
      @hash = {'user' => @list.owner.id, 'resource' => 'tasks', 'filters' => {'priority' => 'high'}}
    end

    it 'returns the correct tasks' do 
      array = [@task]
      expect(get_filtered(@hash)).to eq array
    end
  end
end