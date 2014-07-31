require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  before(:all) do 
    FactoryGirl.create_list(:user_with_task_lists, 2)
    @admin, @user = User.first, User.last
    @admin.update(admin: true)
    @user.default_task_list.tasks.last.update!(status: 'complete')
  end

  describe 'GET' do 
    describe 'task list route' do 
      context 'with authorization' do 
        before(:each) do 
          authorize @user.username, @user.password
          make_request('GET', "/users/#{@user.id}/tasks")
        end
        
        it 'returns all the user\'s tasks' do 
          expect(response_body).to eql @user.tasks.to_json
        end

        it 'returns status 200' do
          expect(response_status).to eql 200
        end
      end

      context 'without authorization' do 
        before(:each) do 
          make_request('GET', "/users/#{@user.id}/tasks")
        end

        it 'doesn\'t return the tasks' do 
          expect(response_body).not_to include @user.tasks.to_json
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
      end

      context 'as admin' do 
        before(:each) do 
          authorize @admin.username, @admin.password
          make_request('GET', "/users/#{@user.id}/tasks")
        end

        it 'returns the user\'s tasks' do 
          expect(response_body).to eql @user.tasks.to_json
        end

        it 'returns status 200' do 
          expect(response_status).to eql 200
        end
      end

      context 'with invalid authorization' do 
        before(:each) do 
          authorize @user.username, @user.id
          make_request('GET', "/users/#{@admin.id}/tasks")
        end

        it 'doesn\'t return the tasks' do 
          expect(response_body).not_to include @admin.tasks.to_json
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
      end
    end

    context 'individual task route' do 
      it 'returns a single task as a JSON object' do 
        get '/tasks/1'
        expect(response_body).to eql json_task(1)
      end
    end
  end

  describe 'POST' do 
    context 'with user authorization' do 
      context 'with valid attributes' do 
        it 'creates a new task' do 
          expect(Task).to receive(:create!)
          authorize @user.username, @user.password
          make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Water the garden' }.to_json)
        end

        it 'returns status 201' do 
          make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Water the garden' }.to_json)
          expect(last_response.status).to eql 201
        end
      end

      context 'with invalid attributes' do 
        it 'attempts to create a new task' do 
          expect(Task).to receive(:create!)
          authorize @user.username, @user.password
          make_request('POST', "/users/#{@user.id}/tasks", { }.to_json)
        end

        it 'returns status 422' do 
          authorize @user.username, @user.password
          make_request('POST', "/users/#{@user.id}/tasks", { }.to_json)
          expect(response_status).to eql 422
        end
      end
    end

    context 'with admin authorization' do 
      it 'creates a new task' do 
        expect(Task).to receive(:create!)
        authorize @admin.username, @admin.password
        make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Water the garden' }.to_json)
      end

      it 'returns status 201' do 
        make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Water the garden' }.to_json)
        expect(request_status).to eql 201
      end
    end

    context 'with invalid authorization' do 
      it 'doesn\'t create a new task' do 
        expect(Task).not_to receive(:create)
        authorize @user.username, @user.password
        make_request('POST', "/users/#{@admin.id}/tasks", { 'title' => 'Mow the lawn' }.to_json)
      end

      it 'returns status 401' do 
        make_request('POST', "/users/#{@admin.id}/tasks", { 'title' => 'Mow the lawn' }.to_json)
        expect(request_status).to eql 401
      end
    end

    context 'without authorization' do 
      it 'doesn\'t attempt to create a task' do 
        expect(Task).not_to receive(:create)
        make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Mow the lawn' }.to_json)
      end

      it 'returns status 401' do 
        make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Mow the lawn' }.to_json)
        expect(response_status).to eql 401
      end
    end
  end

  describe 'PUT' do 
    describe 'update task route' do 
      context 'with valid attributes' do 
        it 'returns status 200' do
          make_request('PUT', '/tasks/1', { 'title' => 'Take the car for service' }.to_json)
          expect(response_status).to eql 200
        end
      end

      context 'with invalid attributes' do 
        it 'returns status 422' do 
          make_request('PUT', '/tasks/1', { 'title' => nil }.to_json)
          expect(response_status).to eql 422
        end
      end
    end
  end

  describe 'DELETE' do 
    context 'when the task exists' do 
      it 'returns status 204' do 
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