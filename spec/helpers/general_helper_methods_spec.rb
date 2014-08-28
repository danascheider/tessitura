require 'spec_helper'

describe Sinatra::GeneralHelperMethods do 
  include Sinatra::GeneralHelperMethods

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