require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  # before(:each) do 
  #   user.tasks.first.update!(status: 'complete')
  # end

  describe 'GET' do 
    describe 'task list route' do 
      context 'with owner authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:resource) { user.tasks.to_json }
          let(:agent) { user }
          let(:path) { "/users/#{user.id}/tasks" }
        end
      end

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:resource) { user.tasks.to_json } 
          let(:agent) { admin }
          let(:path) { "/users/#{user.id}/tasks" }
        end
      end

      context 'with inadequate authorization' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:resource) { admin.tasks.to_json }
          let(:username) { user.username }
          let(:password) { user.password }
          let(:path) { "/users/#{admin.id}" }
        end
      end

      context 'with invalid credentials' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:resource) { user.tasks.to_json }
          let(:username) { 'foo' }
          let(:password) { 'bar' }
          let(:path) { "/users/#{user.id}/tasks" }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials' do 
          let(:resource) { user.tasks.to_json }
          let(:path) { "/users/#{user.id}/tasks" }
        end
      end
    end

    context 'individual task route' do 
      let(:task) { user.tasks.first } 
      let(:resource) { task.to_json }

      context 'with user authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { user }
          let(:path) { "/tasks/#{task.id}" }
        end
      end

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { admin }
          let(:path) { "/tasks/#{task.id}" }
        end
      end

      context 'with invalid authorization' do 
        it_behaves_like 'an unauthorized GET request' do
          let(:resource) { admin.tasks.first.to_json }
          let(:username) { user.username }
          let(:password) { user.password }
          let(:path) { "/tasks/#{admin.tasks.first.id}" } 
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials' do 
          let(:path) { "/tasks/#{task.id}" }
        end
      end

      context 'when the task doesn\'t exist' do 
        it 'returns status 404' do 
          authorize_with user
          make_request('GET', '/tasks/1000000')
          expect(response_status).to eql 404
        end
      end
    end
  end

  describe 'POST' do 

    let(:model) { Task } 
    let(:path) { "/users/#{user.id}/tasks"}
    let(:valid_attributes) { { 'title' => 'Water the garden' }.to_json }
    let(:invalid_attributes) { { 'status' => 'foobar' }.to_json }

    context 'with user authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:agent) { user }
      end
    end

    context 'with admin authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:agent) { admin }
      end

      it 'assigns task ownership to the user, not the admin' do 
        authorize_with admin
        make_request('POST', "/users/#{user.id}/tasks", { 'title' => 'Water the garden' }.to_json)
        expect(Task.last.owner_id).to eql user.id
      end
    end

    context 'with invalid authorization' do 
      it_behaves_like 'an unauthorized POST request' do 
        let(:agent) { user }
        let(:path) { "/users/#{admin.id}/tasks" }
      end
    end

    context 'without authorization' do 
      it_behaves_like 'a POST request without credentials'
    end
  end

  # describe 'PUT' do 
  #   context 'with user authorization' do
  #     context 'with valid attributes' do 
  #       it 'updates the task' do 
  #         # FIX: Might it be better to use :update instead of :update!?
  #         expect_any_instance_of(Task).to receive(:update!)
  #         authorize_with user
  #         make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'title' => 'Take the car for service' }.to_json)
  #       end

  #       it 'returns status 200' do
  #         authorize user.username, user.password
  #         make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'title' => 'Take the car for service' }.to_json)
  #         expect(response_status).to eql 200
  #       end
  #     end

  #     context 'with invalid attributes' do 
  #       it 'returns status 422' do 
  #         authorize_with user
  #         make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'title' => nil }.to_json)
  #         expect(response_status).to eql 422
  #       end
  #     end
  #   end

  #   context 'with admin authorization' do 
  #     it 'updates the task' do 
  #       expect_any_instance_of(Task).to receive(:update!)
  #       authorize_with admin
  #       make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'status' => 'blocking' }.to_json)
  #     end

  #     it 'returns status 200' do 
  #       authorize_with admin
  #       make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'status' => 'blocking' }.to_json)
  #       expect(response_status).to eql 200
  #     end
  #   end

  #   context 'with invalid authorization' do 
  #     it 'doesn\'t update the task' do 
  #       expect_any_instance_of(Task).not_to receive(:update!)
  #       authorize_with user
  #       make_request('PUT', "/tasks/#{admin.tasks.first.id}", { 'status' => 'complete' }.to_json)
  #     end

  #     it 'returns status 401' do 
  #       authorize_with user
  #       make_request('PUT', "/tasks/#{admin.tasks.first.id}", { 'status' => 'complete' }.to_json)
  #       expect(response_status).to eql 401
  #     end
  #   end

  #   context 'without authorization' do 
  #     it 'doesn\'t update the task' do 
  #       expect_any_instance_of(Task).not_to receive(:update!)
  #       make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'priority' => 'high' }.to_json)
  #     end

  #     it 'returns status 401' do 
  #       make_request('PUT', "/tasks/#{user.tasks.first.id}", { 'priority' => 'high' }.to_json)
  #       expect(response_status).to eql 401
  #     end
  #   end

  #   context 'when the task doesn\'t exist' do 
  #     it 'returns status 404' do 
  #       authorize_with admin
  #       make_request('PUT', '/tasks/1000000', { 'status' => 'blocking' }.to_json)
  #       expect(response_status).to eql 404
  #     end
  #   end
  # end

  # describe 'DELETE' do 
  #   context 'with user authorization' do 
  #     context 'when the task exists' do 
  #       it 'deletes the task' do 
  #         expect_any_instance_of(Task).to receive(:destroy!)
  #         authorize_with user
  #         make_request('DELETE', "/tasks/#{user.tasks.first.id}")
  #       end

  #       it 'returns status 204' do 
  #         authorize_with user
  #         make_request('DELETE', "/tasks/#{user.tasks.first.id}")
  #         expect(response_status).to eql 204
  #       end
  #     end

  #     context 'when the task doesn\'t exist' do 
  #       it 'doesn\'t delete anything' do 
  #         expect_any_instance_of(Task).not_to receive(:destroy!)
  #         authorize_with user
  #         make_request('DELETE', "/tasks/1000000")
  #       end

  #       it 'returns status 404' do 
  #         authorize_with user
  #         make_request('DELETE', "/tasks/1000000")
  #         expect(response_status).to eql 404
  #       end
  #     end
  #   end

  #   context 'with admin authorization' do 
  #     it 'deletes the task' do 
  #       expect_any_instance_of(Task).to receive(:destroy!)
  #       authorize_with admin
  #       make_request('DELETE', "/tasks/#{user.tasks.first.id}")
  #     end

  #     it 'returns status 204' do 
  #       authorize_with admin
  #       make_request('DELETE', "/tasks/#{user.tasks.first.id}")
  #       expect(response_status).to eql 204
  #     end
  #   end

  #   context 'with invalid authorization' do 
  #     it 'doesn\'t delete the task' do 
  #       expect_any_instance_of(Task).not_to receive(:destroy!)
  #       authorize_with user
  #       make_request('DELETE', "/tasks/#{admin.tasks.first.id}")
  #     end

  #     it 'returns status 401' do 
  #       authorize_with user
  #       make_request('DELETE', "/tasks/#{admin.tasks.first.id}")
  #     end
  #   end

  #   context 'with no authorization' do 
  #     it 'doesn\'t delete anything' do 
  #       expect_any_instance_of(Task).not_to receive(:destroy!)
  #       make_request('DELETE', "/tasks/#{user.tasks.first.id}")
  #     end

  #     it 'returns status 401' do 
  #       make_request('DELETE', "/tasks/#{user.tasks.first.id}")
  #       expect(response_status).to eql 401
  #     end
  #   end
  # end
end