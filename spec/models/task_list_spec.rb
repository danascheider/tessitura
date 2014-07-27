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
    before(:each) do 
      @last_list = FactoryGirl.create(:task_list_with_tasks)
    end

    it 'is destroyed when the user is destroyed' do 
      @last_list.user.destroy 
      expect(@last_list).not_to be_persisted
    end
  end
end