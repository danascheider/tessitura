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
    describe 'to_a' do 
      it 'returns an array of its tasks' do 
        list = []
        @task_list.tasks.each {|task| list << task }
        expect(@task_list.to_a).to eql list.flatten
      end
    end
  end
end