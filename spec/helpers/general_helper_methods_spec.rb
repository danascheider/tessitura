require 'spec_helper'

describe Canto::GeneralHelperMethods do 
  include Canto::GeneralHelperMethods

  describe '::to_bool' do 
    context 'when false' do 
      it 'returns false' do 
        expect(to_bool('false')).to eql false
      end
    end

    context 'when nil' do 
      it 'returns false' do 
        expect(to_bool('nil')).to eql false
      end
    end

    context 'when true' do 
      it 'returns true' do 
        expect(to_bool('true')).to eql true
      end
    end
  end
end