require 'spec_helper'

describe TaskIndexing do 
  include TaskIndexing 

  context 'no tasks' do 
    it 'does not return a duplicate' do 
      @indices = Task.pluck(:index).sort
      expect(dup).to be nil
    end
  end
end