require 'spec_helper'

describe Task do 
  it { should respond_to(:title) }
  it { should respond_to(:complete) }
  it { should respond_to(:incomplete?) }
  it { should respond_to(:to_hash) } # to integrate with Sinatra-Backbone

  before(:each) do 
    @task = Task.new 
  end

  describe 'validations' do 
    it 'is invalid without a title' do 
      expect(@task).not_to be_valid
    end

    it 'instantiates with valid attributes' do 
      @task.title = 'Call mom'
      expect(@task.save!) 
    end

    it 'doesn\'t update without a title' do 
      task = Task.create(title: 'Go to Fred Meyer')
      expect(task.update(title: nil)).to be false
    end
  end

  describe 'default behavior' do 
    it 'sets :complete to false, not nil' do 
      @task.title = 'Walk the dog'
      @task.save!
      expect(@task.complete).to eql false
    end

    it 'sets :complete to false only if actually false' do 
      @task.complete, @task.title = true, 'Walk the dog'
      @task.save!
      expect(@task.complete).to eql true
    end
  end
end