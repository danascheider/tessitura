require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  describe 'filtering tasks' do 
    before(:each) do 
      @list = FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks, user_id: user.id)
    end

    context 'with user credentials' do 
      before(:each) do 
        authorize_with user
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

    context 'with admin credentials' do 
      before(:each) do 
        authorize_with admin
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

    context 'with unauthorized credentials' do 
      before(:each) do 
        authorize_with user
        make_request('POST', '/filters', { 'user' => admin.id, 'resource' => 'tasks', 'filters' => { 'status' => 'complete' }}.to_json)
      end

      it 'doesn\'t return the tasks' do 
        expect(response_body).to eql "Authorization Required\n"
      end

      it 'returns status 401' do 
        expect(response_status).to eql 401
      end
    end

    context 'with invalid credentials' do 
      before(:each) do 
        authorize 'foo', 'bar'
        make_request('POST', '/filters', { 'user' => @list.user.id, 'resource' => 'tasks', 'filters' => { 'status' => 'complete' }}.to_json)
      end

      it 'doesn\'t return the tasks' do 
        expect(response_body).to eql "Authorization Required\n"
      end

      it 'returns status 401' do 
        expect(response_status).to eql 401
      end
    end

    context 'with no credentials' do 
      before(:each) do 
        make_request('POST', '/filters', { 'user' => @list.user.id, 'resource' => 'tasks', 'filters' => { 'status' => 'complete' }}.to_json)
      end

      it 'doesn\'t return the tasks' do 
        expect(response_body).to eql "Authorization Required\n"
      end

      it 'returns status 401' do 
        expect(response_status).to eql 401
      end
    end
  end
end