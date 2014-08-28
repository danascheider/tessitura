require 'spec_helper'

describe Sinatra::GeneralHelperMethods do 
  include Sinatra::GeneralHelperMethods

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

  describe '::return_json' do 
    context 'hash' do 
      it 'returns JSON' do 
        hash = {foo: 'bar'}
        expect(return_json(hash)).to eql hash.to_json
      end
    end

    context 'empty string' do 
      it 'returns nil' do 
        expect(return_json('')).to eql nil
      end
    end

    context 'nothing' do 
      it 'returns nil' do 
        expect(return_json(nil)).to eql nil
      end
    end
  end
end