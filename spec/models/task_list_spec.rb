require 'spec_helper'

describe TaskList do 
  before(:all) do 
    FactoryGirl.create(:task_list)
  end

  describe 'attributes' do 
    it { should respond_to(:title) }
    it { should respond_to(:user) }
    it { should respond_to(:owner) }
  end
end