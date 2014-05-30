require 'spec_helper'

describe Task do
  it { should respond_to(:title) }
  it { should respond_to(:complete? ) }

  describe 'validations' do 
    before :each do
      @task = Task.new
    end
    
    it 'is invalid without a title' do 
      expect(@task).not_to be_valid
    end
  end
end
