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
end