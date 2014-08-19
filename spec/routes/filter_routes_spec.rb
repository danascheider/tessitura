require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  describe 'filtering tasks' do 
    before(:each) do 
      @list = FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks, user_id: user.id)
      make_request('POST', '/filters', { 'user' => @list.user.id, 'resource' => 'tasks', 'filters' => { 'status' => 'complete' }}.to_json)
    end

    it 'returns the tasks in JSON format' do 
      expected = Task.where(status: 'complete').to_a.map! {|task| task.to_hash }
      expect(response_body).to eql expected.to_json
    end

    it 'returns status 200' do 
      expect(response_status).to eql 200
    end
  end
end