require 'spec_helper'

describe TaskIndexing do 
  include TaskIndexing 

  context 'no tasks' do 
    before(:each) do 
      @indices = Task.pluck(:index).sort
    end

    it 'does not identify a duplicate' do 
      expect(dup).to be nil
    end

    it 'does not identify a gap' do 
      expect(gap).to be nil
    end
  end

  context 'two tasks' do 
    before(:each) do 
      FactoryGirl.create(:task)
    end

    it 'identifies a duplicate' do 
      FactoryGirl.create(:task, index: 1)
      @indices = Task.pluck(:index).sort
      expect(dup).to eql 1
    end

    it 'doesn\'t identify a gap' do 
      FactoryGirl.create(:task, index: 2)
      @indices = Task.pluck(:index).sort
      expect(gap).to be nil
    end
  end
end