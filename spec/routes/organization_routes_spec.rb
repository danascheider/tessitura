require 'spec_helper'

describe Canto, organizations: true do 
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

  describe 'GET' do 
    context 'individual organization' do 
      let(:path) { "/organizations/#{org.id}" }
      let(:resource) { org }

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { FactoryGirl.create(:admin) }
        end
      end
    end
  end

  describe 'PUT' do
    let(:path) { "/organizations/#{org.id}" }
    let(:resource) { org }

    context 'with admin authorization' do 
      it_behaves_like 'an authorized PUT request' do 
        let(:agent) { FactoryGirl.create(:admin) }
      end

      context 'when the organization doesn\'t exist' do 
        it 'returns status 404' do 
          authorize_with FactoryGirl.create(:admin)
          put '/organizations/8320462', {contact_name: 'Shelley Goldschmidt'}.to_json, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.status).to eql 404
        end
      end
    end

    context 'with user authorization' do 
      it_behaves_like 'an unauthorized PUT request' do 
        let(:agent) { FactoryGirl.create(:user) }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a PUT request without credentials'
    end
  end
end