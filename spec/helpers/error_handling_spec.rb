require 'spec_helper'

describe Canto::ErrorHandling do 
  include Canto::ErrorHandling

  describe '::begin_and_rescue' do 
    context 'when no error is raised' do 
      it 'yields output from the block' do 
        expect(begin_and_rescue(StandardError, 500) { 'Hello World' }).to eql 'Hello World'
      end
    end

    context 'when an error is raised' do 
      it 'returns a status code' do 
        expect(begin_and_rescue(ActiveRecord::RecordNotFound, 404) { User.find(100) }).to eql 404
      end
    end
  end
end