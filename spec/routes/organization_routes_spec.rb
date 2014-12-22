require 'spec_helper'

describe Canto do 
  include Sinatra::ErrorHandling
  
  let(:org) { FactoryGirl.create(:organization) }
  let(:model) { Organization }
  let(:valid_attributes) { { name: 'Chicago Lyric Opera', website: 'http://lyricopera.org' }.to_json }
  let(:invalid_attributes) { { name: nil, country: 'Swaziland' }.to_json }

  describe 'POST' do 
    let(:path) { '/organizations' }

    context 'with admin authorization' do 
      it_behaves_like 'an authorized POST request' do 
        let(:agent) { FactoryGirl.create(:admin) }
      end
    end

    context 'with user authorization' do 
      it_behaves_like 'an unauthorized POST request' do 
        let(:agent) { FactoryGirl.create(:user) }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a POST request without credentials'
    end
  end

  describe 'PUT' do
    let(:path) { "/organizations/#{org.id}" }
    let(:resource) { org }

    context 'with admin authorization' do 
      it_behaves_like 'an authorized PUT request' do 
        let(:agent) { FactoryGirl.create(:admin) }
      end
    end

    context 'with user authorization' do 
      it_behaves_like 'an unauthorized PUT request' do 
        let(:agent) { FactoryGirl.create(:user) }
      end
    end
  end
end