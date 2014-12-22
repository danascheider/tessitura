require 'spec_helper'

describe Canto do 
  include Sinatra::ErrorHandling
  
  let(:org) { FactoryGirl.create(:organization) }
  let(:model) { Organization }
  let(:valid_attributes) { { name: 'Chicago Lyric Opera', website: 'http://lyricopera.org' }.to_json }
  let(:invalid_attributes) { { country: 'Swaziland' }.to_json }

  describe 'POST' do 
    context 'with admin authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:path) { '/organizations' }
        let(:agent) { FactoryGirl.create(:admin) }
      end
    end
  end
end