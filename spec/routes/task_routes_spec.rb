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
      context 'with user authorization' do 
        before(:each) do 
          authorize @user.username, @user.password
          make_request('GET', "/tasks/#{@user.tasks.first.id}")
        end

        it 'returns a single task' do 
          expect(response_body).to eql @user.tasks.first.to_json
        end

        it 'returns status 200' do 
          expect(response_status).to eql 200
        end
      end

      context 'with admin authorization' do 
        before(:each) do 
          authorize @admin.username, @admin.password
          make_request('GET', "/tasks/#{@user.tasks.first.id}")
        end

        it 'returns a single task' do 
          expect(response_body).to eql @user.tasks.first.to_json
        end

        it 'returns status 200' do 
          expect(response_status).to eql 200
        end
      end

      context 'with invalid authorization' do 
        before(:each) do 
          authorize @user.username, @user.password
          make_request('GET', "/tasks/#{@admin.tasks.first.id}")
        end

        it 'doesn\'t return a task' do 
          expect(response_body).not_to include @admin.tasks.first.to_json
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
      end

      context 'with no authorization' do 
        before(:each) do 
          make_request('GET', "/tasks/#{@user.tasks.first.id}")
        end

        it 'doesn\'t return a task' do 
          expect(response_body).not_to include @user.tasks.first.to_json
        end

        it 'returns status 401' do 
          expect(response_status).to eql 401
        end
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
          authorize @user.username, @user.password
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
        authorize @admin.username, @admin.password
        make_request('POST', "/users/#{@user.id}/tasks", { 'title' => 'Water the garden' }.to_json)
        expect(response_status).to eql 201
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
        expect(response_status).to eql 401
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
    context 'with user authorization' do
      context 'with valid attributes' do 
        it 'updates the task' do 
          # FIX: Might it be better to use :update instead of :update!?
          expect_any_instance_of(Task).to receive(:update!)
          authorize @user.username, @user.password
          make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'title' => 'Take the car for service' }.to_json)
        end

        it 'returns status 200' do
          authorize@user.username, @user.password
          make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'title' => 'Take the car for service' }.to_json)
          expect(response_status).to eql 200
        end
      end

      context 'with invalid attributes' do 
        it 'returns status 422' do 
          authorize @user.username, @user.password
          make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'title' => nil }.to_json)
          expect(response_status).to eql 422
        end
      end
    end

    context 'with admin authorization' do 
      it 'updates the task' do 
        expect_any_instance_of(Task).to receive(:update!)
        authorize @admin.username, @admin.password
        make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'status' => 'blocking' }.to_json)
      end

      it 'returns status 200' do 
        authorize @admin.username, @admin.password
        make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'status' => 'blocking' }.to_json)
        expect(response_status).to eql 200
      end
    end

    context 'with invalid authorization' do 
      it 'doesn\'t update the task' do 
        expect_any_instance_of(Task).not_to receive(:update!)
        authorize @user.username, @user.password
        make_request('PUT', "/tasks/#{@admin.tasks.first.id}", { 'status' => 'complete' }.to_json)
      end

      it 'returns status 401' do 
        authorize @user.username, @user.password
        make_request('PUT', "/tasks/#{@admin.tasks.first.id}", { 'status' => 'complete' }.to_json)
        expect(response_status).to eql 401
      end
    end

    context 'without authorization' do 
      it 'doesn\'t update the task' do 
        expect_any_instance_of(Task).not_to receive(:update!)
        make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'priority' => 'high' }.to_json)
      end

      it 'returns status 401' do 
        make_request('PUT', "/tasks/#{@user.tasks.first.id}", { 'priority' => 'high' }.to_json)
        expect(response_status).to eql 401
      end
    end
  end

  describe 'DELETE' do 
    context 'with user authorization' do 
      context 'when the task exists' do 
        it 'deletes the task' do 
          expect_any_instance_of(Task).to receive(:destroy!)
          authorize @user.username, @user.password
          make_request('DELETE', "/tasks/#{@user.tasks.first.id}")
        end

        it 'returns status 204' do 
          authorize @user.username, @user.password
          make_request('DELETE', "/tasks/#{@user.tasks.first.id}")
          expect(response_status).to eql 204
        end
      end

      context 'when the task doesn\'t exist' do 
        it 'doesn\'t delete anything' do 
          expect_any_instance_of(Task).not_to receive(:destroy!)
          authorize @user.username, @user.password
          make_request('DELETE', "/tasks/1000000")
        end

        it 'returns status 404' do 
          authorize @user.username, @user.password
          make_request('DELETE', "/tasks/1000000")
          expect(response_status).to eql 404
        end
      end
    end

    context 'with admin authorization' do 
      it 'deletes the task' do 
        expect_any_instance_of(Task).to receive(:destroy!)
        authorize @admin.username, @admin.password
        make_request('DELETE', "/tasks/#{@user.tasks.first.id}")
      end

      it 'returns status 204' do 
        authorize @admin.username, @admin.password
        make_request('DELETE', "/tasks/#{@user.tasks.first.id}")
        expect(response_status).to eql 204
      end
    end

    context 'with invalid authorization' do 
      it 'doesn\'t delete the task' do 
        expect_any_instance_of(Task).not_to receive(:destroy!)
        authorize @user.username, @user.password
        make_request('DELETE', "/tasks/#{@admin.tasks.first.id}")
      end

      it 'returns status 401' do 
        authorize @user.username, @user.password
        make_request('DELETE', "/tasks/#{@admin.tasks.first.id}")
      end
    end

    context 'with no authorization' do 
      it 'doesn\'t delete anything' do 
        expect_any_instance_of(Task).not_to receive(:destroy!)
        make_request('DELETE', "/tasks/#{@user.tasks.first.id}")
      end

      it 'returns status 401' do 
        make_request('DELETE', "/tasks/#{@user.tasks.first.id}")
        expect(response_status).to eql 401
      end
    end
  end
end