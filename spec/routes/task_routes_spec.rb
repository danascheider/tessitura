require 'spec_helper'

describe Tessitura, tasks: true, routes: true do 
  include Sinatra::ErrorHandling
  include Sinatra::GeneralHelperMethods
  include Rack::Test::Methods 

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }
  let(:model) { Task }

  describe 'GET', type: :get do 
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

      context 'authorized user with no tasks' do 
        before(:each) do 
          user = FactoryGirl.create(:user)
          authorize_with(user)
          get "/users/#{user.id}/tasks"
        end

        it 'returns an empty JSON object' do 
          expect(last_response.body).to eql([].to_json)
        end

        it 'returns status 200' do 
          expect(last_response.status).to eql(200)
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
          # allow_any_instance_of(Tessitura).to receive(:protect).with(Task).and_return(nil)
          get '/tasks/1000000'
          expect(last_response.status).to eql 404
        end
      end
    end
  end

  describe 'POST', type: :post do 
    let(:path) { "/users/#{user.id}/tasks"}
    let(:valid_attributes) { 
      { :title => 'Water the garden', 
        :status => 'New', 
        :priority => 'Normal',
        :task_list_id => user.default_task_list.id 
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
            :priority => 'Normal',
            :task_list_id => user.default_task_list.id
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

  describe 'PUT', type: :put do 
    context 'single task route' do 
      let(:path) { "/tasks/#{user.tasks.first.id}" }
      let(:valid_attributes) { { :title => 'Fix bad RSpec expectations' }.to_json }
      let(:invalid_attributes) { { :title => nil }.to_json }
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
          allow_any_instance_of(Tessitura).to receive(:protect).with(Task).and_return(nil)
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
      let(:models) { user.tasks[0..1] }
      let(:resource) { models.map {|t| t.to_h }}

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
          { id: resource[0][:id], position: 2 },
          { id: admin.tasks.first.id, position: 3 }
        ]
      }

      let(:path) {
        "/users/#{user.id}/tasks"
      }

      it 'calls ::protect_collection' do 
        expect_any_instance_of(Tessitura).to receive(:protect_collection).with(valid_attributes)
        put path, valid_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
      end

      context 'with user authorization' do 
        it_behaves_like 'an authorized multiple update' do 
          let(:agent) { user }
        end

        context 'forbidden attributes' do 
          it_behaves_like 'an unauthorized multiple update' do 
            let(:username) { user.username }
            let(:password) { user.password }
            let(:valid_attributes) { forbidden_attributes } # just this once
          end
        end
      end

      context 'with admin authorization' do 
        it_behaves_like 'an authorized multiple update' do 
          let(:agent) { admin }
        end

        context 'forbidden attributes' do 
          before(:each) do 
            authorize_with admin
            put path, forbidden_attributes.to_json, 'CONTENT_TYPE' => 'application/json'
          end

          it 'doesn\'t persist any changes' do 
            a = models.map {|model| [model.class[model.id], forbidden_attributes[models.index(model)]] }

            a.each do |arr|
              arr[1].reject! {|key, value| key === :id }
              arr[1].each {|key, value| expect(arr[0].send(key)).not_to eql value }
            end
          end

          it 'returns status 422' do 
            expect(last_response.status).to eql 422
          end
        end
      end

      context 'with invalid authorization' do 
        it_behaves_like 'an unauthorized multiple update' do 
          let(:username) { 'foo' }
          let(:password) { 'bar' }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'an unauthorized multiple update' do 
          let(:username) { nil }
          let(:password) { nil }
        end
      end
    end
  end

  describe 'DELETE', type: :delete do 
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