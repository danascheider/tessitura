require 'spec_helper'

describe Task do 
  it { should respond_to(:title) }
  it { should respond_to(:complete) }
  it { should respond_to(:incomplete?) }
  it { should respond_to(:to_hash) } # to integrate with Sinatra-Backbone

  describe 'validations' do 
    it 'is invalid without a title' do 
      @task = Task.new
      expect(@task).not_to be_valid
    end
  end
end