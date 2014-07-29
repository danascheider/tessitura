require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    FactoryGirl.create_list(:user_with_task_lists, 2)
    @admin = User.first.update(admin: true)
    @user = User.last
    @user.default_task_list.tasks.last.update!(status: 'complete')
  end

  describe 'GET' do 
    describe 'task list route' do 
      context 'with authorization' do 
        before(:each) do 
          make_request('GET', "/users/#{@user.id}/tasks", { secret_key: @user.secret_key }.to_json)
        end

        it 'returns all the user\'s tasks' do 
          expect(response_body).to eql @user.tasks.to_json
        end

        it 'returns status code 200' do 
          expect(repsonse_status).to eql 200
        end
      end

      context 'without authorization' do 
        before(:each) do 
          make_request('GET', "/users/#{@user.id}/tasks")
        end

        it 'doesn\'t return the tasks' do 
          expect(response_body).not_to include @user.tasks.to_json
        end

        it 'returns status code 401' do 
          expect(response_status).to eql 401
        end
      end

      context 'as admin' do 
        before(:each) do 
          make_request('GET', "/users/#{@user.id}/tasks", {'secret_key' => @admin.secret_key }.to_json)
        end

        it 'returns the user\'s tasks' do 
          expect(response_body).to eql @user.tasks.to_json
        end

        it 'returns status code 200' do 
          expect(response_status).to eql 200
        end
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