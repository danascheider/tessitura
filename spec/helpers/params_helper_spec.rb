require 'spec_helper'

describe Canto::ParamsHelper do 
  include Canto::ParamsHelper

  before(:all) do 
    @valid_params = { 'status' => 'blocking', 'priority' => 'high' }
    @invalid_params = { 'complete' => 'false', 'foo' => 'bar' }
  end

  describe 'validate_params method' do 
    context 'with valid params' do
      it 'returns the params hash' do 
        expect(validate_params(@valid_params)).to eql @valid_params
      end
    end

    context 'with invalid params' do 
      it 'returns only allowed params' do 
        expect(validate_params(@invalid_params)).to eql({ 'complete' => 'false' })
      end
    end
  end

  describe 'multiple_values? method' do 
    context 'when a string contains multiple values' do 
      it 'returns true' do 
        expect(multiple_values? 'in_progress,blocking').to be true
      end
    end

    context 'when a string contains a single value' do 
      it 'returns false' do 
        expect(multiple_values? 'high').to be false
      end
    end
  end

  describe 'parse_multiple_values method' do 
    it 'returns an array of symbols' do 
      output = parse_multiple_values('urgent,high,normal')
      expect(output).to eql([:urgent, :high, :normal])
    end
  end
end