require 'spec_helper'

describe Canto do 
  include Sinatra::ErrorHandling
  include Rack::Test::Methods 

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_complete_and_incomplete_tasks) }
  let(:model) { Task }

  describe 'GET' do 
    describe 'main task list route' do 
      let(:path) { "/users/#{user.id}/tasks" }
      let(:resource) { user.tasks.where_not(:status, 'Complete').map {|t| t.to_hash } }

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
          let(:resource) { admin.tasks.where_not(:status, 'Complete').map {|t| t.to_hash } }
          let(:username) { user.username }
          let(:password) { user.password }
          let(:path) { "/users/#{admin.id}" }
        end
      end

      context 'with invalid credentials' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:resource) { user.tasks.where_not(:status, 'Complete').map {|t| t.to_hash } }
          let(:username) { 'foo' }
          let(:password) { 'bar' }
          let(:path) { "/users/#{user.id}/tasks" }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials' do 
          let(:resource) { user.tasks.map {|t| t.to_hash } }
          let(:path) { "/users/#{user.id}/tasks" }
        end
      end
    end

    describe 'full task list route' do 
      let(:path) { "/users/#{user.id}/tasks/all" }
      let(:resource) { user.tasks.map {|t| t.to_h } }

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

      context 'with wrong authorization' do
        it_behaves_like 'an unauthorized GET request' do 
          let(:path) { "/users/#{admin.id}/tasks/all" }
          let(:resource) { admin.tasks.map {|t| t.to_h } }
          let(:username) { user.username }
          let(:password) { user.password }
        end
      end

      context 'with invalid credentials' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:username) { 'foo' }
          let(:password) { 'bar' }
        end
      end

      context 'with no credentials' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:username) { nil }
          let(:password) { nil }
        end
      end
    end

    context 'individual task route' do 
      let(:task) { user.tasks.first } 
      let(:resource) { task }

      context 'with user authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { user }
          let(:task) { user.tasks.first }
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
          let(:resource) { admin.tasks.first }
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
          # allow_any_instance_of(Canto).to receive(:protect).with(Task).and_return(nil)
          get '/tasks/1000000'
          expect(last_response.status).to eql 404
        end
      end
    end
  end

  describe 'POST' do 
    let(:path) { "/users/#{user.id}/tasks"}
    let(:valid_attributes) { 
      { :title => 'Water the garden', 
        :status => 'New', 
        :priority => 'Normal' 
      }.to_json
    }

    let(:invalid_attributes) { { 'status' => 'foobar' }.to_json }

    context 'with user authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:agent) { user } 
      end
    end

    context 'with admin authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:agent) { admin }
        let(:valid_attributes) { 
          { 
            :title => 'Water the garden', 
            :status => 'New', 
            :priority => 'Normal' 
          }.to_json
        }
      end

      it 'assigns task ownership to the user, not the admin' do 
        authorize_with admin
        post "/users/#{user.id}/tasks", { :title => 'Water the garden' }.to_json, 'CONTENT_TYPE' => 'application/json'
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
    context 'single task route' do 
      let(:valid_attributes) { { status: 'Blocking' }.to_json }
      let(:invalid_attributes) { { status: 'doomed' }.to_json }
      let(:path) { "/tasks/#{user.tasks.first.id}" }
      let(:resource) { user.tasks.first }

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
          let(:task) { FactoryGirl.create(:task, task_list_id: admin.task_lists.first.id) }
          let(:path) { "/tasks/#{task.id}"}
        end
      end

      context 'without authorization' do 
        it_behaves_like 'a PUT request without credentials'
      end

      context 'when the task doesn\'t exist' do 
        it 'returns status 404' do 
          allow_any_instance_of(Canto).to receive(:protect).with(Task).and_return(nil)
          put '/tasks/1000000', { :status => 'Blocking' }.to_json, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.status).to eql 404
        end

        it 'doesn\'t return a response body' do 
          # To my future self: I am including this  because this behavior has 
          # failed to work as expected. Don't refactor it away.
          put '/tasks/1000000', { :status => 'Blocking' }.to_json, 'CONTENT_TYPE' => 'application/json'
          expect(parse_json(last_response.body)).to eql nil
        end
      end
    end

    context 'mass update route' do 
      let(:resource) { user.tasks[0..1].map {|t| t.to_h } }

      let(:valid_attributes) {
        [
          { id: resource[0][:id], position: 2 }, 
          { id: resource[1][:id], position: 3 }
        ]        
      }

      let(:invalid_attributes) {
        [
          { id: resource[0][:id], position: 2 },
          { id: resource[1][:id], title: nil }
        ]
      }

      let(:forbidden_attributes) {
        [
          { id: resource[0][:id], title: nil },
          { id: admin.tasks.first.id, position: 3 }
        ]
      }

      let(:path) {
        "/users/#{user.id}/tasks"
      }

      it 'calls ::protect_collection' do 
        expect_any_instance_of(Canto).to receive(:protect_collection).with(valid_attributes)
        put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      context 'with user authorization' do 
        before(:each) do 
          @task1, @task2 = Task[resource[0][:id]], Task[resource[1][:id]]
          authorize_with user 
        end

        context 'valid attributes' do 
          it 'calls ::set_attributes' do 
            expect_any_instance_of(Canto).to receive(:set_attributes).with(valid_attributes[0], @task1)
            expect_any_instance_of(Canto).to receive(:set_attributes).with(valid_attributes[1], @task2)

            put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
          end

          it 'saves the tasks' do 
            put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
            a = [
                  [Task[@task1.id], valid_attributes[0][:position]],
                  [Task[@task2.id], valid_attributes[1][:position]]
                ]

            a.each do |arr|
              expect(arr[0].position).to eql(arr[1])
              expect(arr[0]).not_to be_modified
            end
          end

          it 'returns status 200' do 
            put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.status).to eql 200
          end
        end

        context 'invalid attributes' do 
          it 'doesn\'t persist any changes' do 
            expect_any_instance_of(Task).not_to receive(:save)
            put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
          end

          it 'reverts even valid tasks to their original form' do 
            expect(Task[@task1.id].position).to be_nil
          end

          it 'returns status 422' do 
            put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.status).to eql 422
          end
        end
      end

      context 'with admin authorization' do 
        before(:each) do 
          @task1, @task2 = Task[resource[0][:id]], Task[resource[1][:id]]
          authorize_with admin
        end

        context 'valid attributes' do 
          it 'calls ::set_attributes' do 
            expect_any_instance_of(Canto).to receive(:set_attributes).with(valid_attributes[0], @task1)
            expect_any_instance_of(Canto).to receive(:set_attributes).with(valid_attributes[1], @task2)

            put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
          end

          it 'saves the tasks' do 
            put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'

            a = [
                  [Task[@task1.id], valid_attributes[0][:position]],
                  [Task[@task2.id], valid_attributes[1][:position]]
                ]

            a.each do |arr|
              expect(arr[0].position).to eql(arr[1])
              expect(arr[0]).not_to be_modified
            end
          end

          it 'returns status 200' do 
            put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.status).to eql 200
          end
        end

        context 'invalid attributes' do 
          it 'doesn\'t persist any changes' do 
            expect_any_instance_of(Task).not_to receive(:save)
            put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
          end

          it 'reverts even valid tasks to their original form' do 
            expect(Task[@task1.id].position).to be_nil
          end

          it 'returns status 422' do 
            put path, invalid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
            expect(last_response.status).to eql 422
          end
        end
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