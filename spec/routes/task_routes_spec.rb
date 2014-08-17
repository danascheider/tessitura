require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods 
  include Canto::ErrorHandling

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }
  let(:model) { Task }

  describe 'GET' do 
    describe 'task list route' do 
      let(:path) { "/users/#{user.id}/tasks" }
      let(:resource) { user.tasks.to_json }

      context 'with owner authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { user }
        end
      end

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { admin }
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
          allow_any_instance_of(Canto).to receive(:protect).with(Task).and_return(nil)
          make_request('GET', '/tasks/1000000')
          expect(response_status).to eql 404
        end
      end
    end
  end

  describe 'POST' do 
    let(:path) { "/users/#{user.id}/tasks"}
    let(:valid_attributes) { { title: 'Water the garden', task_list_id: user.default_task_list.id }.to_json }
    let(:invalid_attributes) { { status: 'foobar' }.to_json }

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

  describe 'PUT' do 
    let(:task) { user.tasks.first }
    let(:valid_attributes) { { status: 'blocking' }.to_json }
    let(:invalid_attributes) { { priority: 'MOST IMPORTANT THING EVER OMG!!!!!' }.to_json }
    let(:path) { "/tasks/#{task.id}" }

    context 'with user authorization' do
      it_behaves_like 'an authorized PUT request' do 
        let(:agent) { user }
      end
    end

    context 'with admin authorization' do 
      it_behaves_like 'an authorized PUT request' do 
        let(:agent) { admin }
      end
    end

    context 'with invalid authorization' do 
      it_behaves_like 'an unauthorized PUT request' do 
        let(:agent) { user }
        let(:task) { admin.tasks.first }
        let(:path) { "/tasks/#{task.id}"}
      end
    end

    context 'without authorization' do 
      it_behaves_like 'a PUT request without credentials'
    end

    context 'when the task doesn\'t exist' do 
      it 'returns status 404' do 
        allow_any_instance_of(Canto).to receive(:protect).with(Task).and_return(nil)
        make_request('PUT', '/tasks/1000000', { 'status' => 'blocking' }.to_json)
        expect(response_status).to eql 404
      end
    end
  end

  describe 'DELETE' do 
    let(:task) { user.tasks.first }
    let(:path) { "/tasks/#{task.id}" }

    context 'with user authorization' do 
      it_behaves_like 'an authorized DELETE request' do 
        let(:agent) { user }
        let(:nonexistent_resource_path) { '/tasks/1000000' }
      end
    end

    context 'with admin authorization' do 
      it_behaves_like 'an authorized DELETE request' do 
        let(:agent) { admin }
        let(:nonexistent_resource_path) { "/tasks/1000000"}
      end
    end

    context 'with invalid authorization' do 
      it_behaves_like 'an unauthorized DELETE request' do 
        let(:task) { admin.tasks.first }
        let(:path) { "/tasks/#{task.id}" }
        let(:agent) { user }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a DELETE request without credentials'
    end
  end
end