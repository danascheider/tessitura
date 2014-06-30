require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    Task.create!(title: 'Walk the dog')
    Task.create!(title: 'Take out the trash')
    Task.create!(title: 'Call mom', complete: true)
    @task_count = Task.count
  end

  describe 'GET' do 
    context 'task list route' do 
      it 'returns all the tasks as a JSON object' do 
        get '/tasks'
        expect(last_response.body).to eql Task.all.to_json
      end
    end

    context 'individual task route' do 
      it 'returns a single task as a JSON object' do 
        get '/tasks/1'
        expect(last_response.body).to eql Task.find(1).to_json
      end
    end

    context 'scoped task route' do 
      it 'returns only the incomplete tasks' do 
        get 'tasks?complete=false'
        expect(last_response.body).not_to include(Task.find(3).to_json)
      end
    end
  end

  context 'POST' do 
    describe 'new task route' do 
      context 'valid attributes' do 
        before(:all) do 
          post '/tasks', { 'title' => 'Water the garden' }.to_json, 'CONTENT-TYPE' => 'application/json'
        end

        it 'creates a new task' do 
          expect(Task.count - @task_count).to eql 1
        end

        it 'returns status code 201' do 
          expect(last_response.status).to eql 201
        end

      end
    end
  end
end