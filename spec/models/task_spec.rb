require 'rails_helper'

describe Task do
  it { should respond_to(:title) }
  it { should respond_to(:complete? ) }
  it { should respond_to(:incomplete? ) }
  it { should respond_to(:mark_complete) }

  describe 'validations' do 
    before :each do
      @task = Task.new
    end
    
    it 'is invalid without a title' do 
      expect(@task).not_to be_valid
    end
  end

  describe 'scope "complete"' do 
    it 'returns all completed tasks' do 
      Task.complete.should == Task.where(complete: true)
    end
  end

  describe 'scope "incomplete"' do 
    it 'returns all incomplete tasks' do 
      Task.incomplete.should == Task.where(complete: false)
    end
  end

  describe 'default value of :complete' do 
    it 'is created with complete: false' do 
      t = Task.create(title: 'Test Task')
      t.complete.should be false
    end
  end

  describe 'mark_complete' do 
    it 'changes status to complete=true' do 
      t = Task.create(title: 'Test Task')
      t.mark_complete
      t.complete.should be true
    end
  end
end