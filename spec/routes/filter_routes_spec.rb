require 'spec_helper'

describe Canto do 
  include Rack::Test::Methods

  let(:admin) { FactoryGirl.create(:user_with_task_lists, admin: true) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }

  describe 'filtering tasks' do 
    let(:expected) { Task.where(status: 'complete').to_a.map! {|task| task.to_hash } }
    
    before(:each) do 
      @list = FactoryGirl.create(:task_list_with_complete_and_incomplete_tasks, user_id: user.id)
    end

    context 'with user credentials' do 
      it_behaves_like 'an authorized POST request to /filters' do 
        let(:agent) { @list.user }
      end
    end

    context 'with admin credentials' do 
      it_behaves_like 'an authorized POST request to /filters' do 
        let(:agent) { admin }
      end
    end

    context 'with unauthorized credentials' do 
      it_behaves_like 'an unauthorized POST request to /filters' do 
        let(:authenticate) { authorize_with user }
        let(:user_id) { admin.id }
      end
    end

    context 'with invalid credentials' do 
      it_behaves_like 'an unauthorized POST request to /filters' do 
        let(:authenticate) { authorize 'foo', 'bar' }
        let(:user_id) { @list.user.id }
      end
    end

    context 'with no credentials' do 
      it_behaves_like 'an unauthorized POST request to /filters' do 
        let(:authenticate) { nil }
        let(:user_id) { @list.user.id }
      end
    end
  end
end