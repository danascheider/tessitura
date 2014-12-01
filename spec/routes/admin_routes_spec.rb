require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods
  include Sinatra::ErrorHandling

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }
  let(:path) { '/admin/users' }

  describe 'viewing all users' do 
    let(:resource) { User.all }

    context 'with valid authorization' do 
      it_behaves_like 'an authorized GET request' do 
        let(:agent) { admin }
      end
    end

    context 'without valid authorization' do 
      it_behaves_like 'an unauthorized GET request' do 
        let(:username) { user.username }
        let(:password) { user.password }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a GET request without credentials'
    end
  end

  describe 'creating an admin' do 
    let(:model) { User }
    let(:valid_attributes) { 
      { :username => 'abcd1234', 
        :password => 'abcde12345', 
        :email => 'a@example.com', 
        :admin => true 
      }.to_json
    }
    let(:invalid_attributes) { { :admin => true }.to_json }

    context 'with valid authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:agent) { admin }
      end
    end

    context 'with invalid authorization' do 
      it_behaves_like 'an unauthorized POST request' do 
        let(:agent) { user }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a POST request without credentials'
    end
  end
end