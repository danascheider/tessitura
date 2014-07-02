require 'spec_helper'

describe Task do 
  it { should respond_to(:title) }
  it { should respond_to(:complete) }
  it { should respond_to(:index) }
  it { should respond_to(:incomplete?) }
  it { should respond_to(:to_hash) } # to integrate with Sinatra-Backbone

  before(:each) do 
    @task = Task.new 
  end

  describe 'validations' do 
    context ' pertaining to the index' do
      before(:all) do 
        Task.create!(title: 'Filo mio')
        Task.create!(title: 'My string')
      end

      after(:all) do 
        Task.where.not(id: 1).destroy
      end

      it 'prioritizes the new task\'s index' do 
        Task.create!(title: 'Feed the fish', index: 2)
        expect(Task.last.index).to eql 2
      end

      it 'changes the index of the other task' do 
        expect(get_changed.index).to eql 3
      end
    end

    it 'is invalid without a title' do 
      expect(@task).not_to be_valid
    end

    it 'instantiates with valid attributes' do 
      @task.title = 'Call mom'
      expect(@task.save!) 
    end

    it 'doesn\'t update without a title' do 
      task = Task.create(title: 'Go to Fred Meyer')
      expect(!task.update(title: nil))
    end

    it 'updates with valid attributes' do 
      task = Task.create(title: 'Go to Fred Meyer')
      expect(task.update(title: 'Go to Home Depot'))
    end
  end

  describe 'default behavior' do 
    it 'instantiates at index 1' do 
      @task.title = 'Walk the dog'
      @task.save!
      expect(@task.index).to eql 1
    end

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