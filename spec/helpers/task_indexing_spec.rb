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
end