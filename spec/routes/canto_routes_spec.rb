require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    3.times { FactoryGirl.create(:task)}
    Task.find(3).update!(complete: true)
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
        it 'returns status code 201' do 
          make_request('POST', '/tasks', { 'title' => 'Water the garden' }.to_json)
          expect(last_response.status).to eql 201
        end
      end

      context 'invalid attributes' do 
        it 'returns status code 422' do 
          make_request('POST', '/tasks', { }.to_json)
          expect(response_status).to eql 422
        end
      end
    end
  end

  describe 'PUT' do 
    describe 'update task route' do 
      context 'with valid attributes' do 
        it 'returns status code 200' do
          make_request('PUT', '/tasks/1', { 'title' => 'Take the car for service' }.to_json)
          expect(response_status).to eql 200
        end
      end

      context 'with invalid attributes' do 
        it 'returns status code 422' do 
          make_request('PUT', '/tasks/1', { 'title' => nil }.to_json)
          expect(response_status).to eql 422
        end
      end
    end
  end

  describe 'DELETE' do 
    context 'when the task exists' do 
      it 'returns status code 204' do 
        make_request('DELETE', '/tasks/1')
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