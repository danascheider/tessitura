require 'spec_helper'

describe TaskList do 
  before(:all) do 
    @task_list = FactoryGirl.create(:task_list_with_tasks)
  end

  describe 'attributes' do 
    it { should respond_to(:title) }
    it { should respond_to(:user) }
    it { should respond_to(:owner) }
  end

  describe 'instance methods' do 
    describe 'to_hashes' do 
      it 'returns an array of its tasks as hashes' do 
        list = @task_list.tasks.map {|task| task.to_hash }
        expect(@task_list.to_a).to eql list
      end
    end
  end

  describe 'associations' do 
    it 'is destroyed when the user is destroyed' do 
      last_list = FactoryGirl.create(:task_list)
      last_list.user.destroy 
      expect { TaskList.find(last_list.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'creation' do 
    before(:each) do 
      @new_list = FactoryGirl.build(:task_list, user_id: nil)
    end

    it 'is invalid without a user' do 
      expect(@new_list).not_to be_valid
    end

    it 'is valid when a user is present' do 
      @new_list.user_id = @task_list.user.id 
      expect(@new_list).to be_valid
    end
  end
end