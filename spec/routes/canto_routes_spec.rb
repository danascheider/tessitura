require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    3.times {|n| FactoryGirl.create(:task, index: n + 1)}
    @task_count = Task.count
  end

  describe 'GET' do 
    context 'task list route' do 
      it 'returns all the tasks as a JSON object' do 
        get '/tasks'
        expect(response_body).to eql Task.all.to_json
      end
    end

    context 'individual task route' do 
      it 'returns a single task as a JSON object' do 
        get '/tasks/1'
        expect(response_body).to eql json_task(1)
      end
    end

    context 'scoped task route' do 
      it 'returns only the incomplete tasks' do 
        get 'tasks?complete=false'
        expect(response_body).not_to include(json_task(3))
      end
    end
  end

  describe 'POST' do 
    describe 'new task route' do 
      context 'valid attributes' do 
        before(:each) do 
          make_request('POST', '/tasks', { 'title' => 'Water the garden' }.to_json)
        end

        it 'creates a new task' do 
          expect(Task.count - @task_count).to eql 1
        end

        it 'returns status code 201' do 
          expect(last_response.status).to eql 201
        end
      end

      context 'invalid attributes' do 
        before(:each) do 
          make_request('POST', '/tasks', { }.to_json)
        end

        it 'doesn\'t create a new task' do 
          expect(Task.count).to eql @task_count
        end

        it 'returns status code 422' do 
          expect(response_status).to eql 422
        end
      end
    end
  end

  describe 'PUT' do 
    describe 'update task route' do 
      context 'valid attributes' do 
        before(:each) do
          make_request('PUT', '/tasks/1', { 'title' => 'Take the car for service' }.to_json)
        end

        it 'updates the task' do 
          expect(Task.find(1).title).to eql 'Take the car for service'
        end

        it 'returns status code 200' do
          expect(response_status).to eql 200
        end
      end

      context 'invalid attributes' do 
        before(:each) do 
          Task.find(1).update!(title: 'Walk the dog')
          make_request('PUT', '/tasks/1', { 'title' => nil }.to_json)
        end

        it 'doesn\'t update the task' do 
          expect(Task.find(1).title).to eql 'Walk the dog'
        end

        it 'returns status code 422' do 
          expect(response_status).to eql 422
        end
      end
    end
  end

  describe 'DELETE' do 
    context 'when the task exists' do 
      before(:each) do 
        make_request('DELETE', '/tasks/1')
      end

      it 'deletes the task' do 
        expect(Task.exists?(id: 1)).to be false
      end

      it 'returns status code 204' do 
        expect(response_status).to eql 204
      end
    end

    context 'when the task doesn\'t exist' do 
      it 'returns status 404' do 
        make_request('DELETE', '/tasks/15')
        expect(response_status).to eql 404
      end
    end
  end
end