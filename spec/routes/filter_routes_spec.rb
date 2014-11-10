require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods
  include Sinatra::ErrorHandling

  let(:admin) { FactoryGirl.create(:user, admin: true) } 
  let(:alice) { FactoryGirl.create(:user) }
  let(:tasks) { FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks, user_id: alice.id) }
  let(:filter) { {resource: 'Task', scope: :incomplete}.to_json }
  let(:path)  { "/users/#{alice.id}/filter" }

  context 'valid authorization' do 
    before(:each) do 
      @tasks = tasks
      authorize_with(alice)
      post path, filter, 'CONTENT-TYPE' => 'application/json'
    end

    it 'includes all resources filling the criteria' do 
      @tasks.to_hashes.each do |task|
        expect(response_body).to include(task.to_json) unless task[:status] == 'Complete'
      end
    end

    it 'doesn\'t return other resources' do 
      JSON.parse(response_body).each do |task|
        expect(task['status']).not_to eql 'Complete'
      end
    end

    it 'only returns resources belonging to the given user' do 
      JSON.parse(response_body).each do |task|
        expect(task['task_list_id']).to eql alice.task_lists.first.id
      end
    end

    it 'returns status 200' do 
      expect(response_status).to eql 200
    end
  end

  context 'admin authorization' do 
    before(:each) do 
      @tasks = tasks 
      authorize_with(admin)
      post path, filter, 'CONTENT-TYPE' => 'application/json'
    end

    it 'includes all the resources filling the criteria' do 
      @tasks.to_hashes.each do |task|
        expect(response_body).to include(task.to_json) unless task[:status] == 'Complete'
      end
    end

    it 'doesn\'t return other resources' do 
      JSON.parse(response_body).each do |task|
        expect(task['status']).not_to eql 'Complete'
      end
    end

    it 'only returns resources belonging to the given user' do 
      JSON.parse(response_body).each do |task|
        expect(task['task_list_id']).to eql alice.task_lists.first.id
      end
    end

    it 'returns status 200' do 
      expect(response_status).to eql 200
    end
  end

  context 'invalid authorization' do 
    before(:each) do 
      authorize 'foo', 'bar'
      post path, filter, 'CONTENT-TYPE' => 'application/json'
    end

    it 'returns status 401' do 
      expect(response_status).to eql 401
    end

    it 'says "Authorization Required"' do 
      expect(response_body).to eql "Authorization Required\n"
    end
  end

  context 'no authorization' do 
    before(:each) do 
      post path, filter, 'CONTENT-TYPE' => 'application/json'
    end

    it 'returns status 401' do 
      expect(response_status).to eql 401
    end

    it 'says "Authorization Required"' do 
      expect(response_body).to eql "Authorization Required\n"
    end
  end
end