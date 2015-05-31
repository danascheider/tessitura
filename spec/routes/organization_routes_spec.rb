require 'spec_helper'

describe Tessitura, organizations: true do 
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

      context 'with user authorization' do 
        it_behaves_like 'an authorized GET request' do
          let(:agent) { FactoryGirl.create(:user) }
        end
      end

      context 'with invalid credentials' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:username) { 'baduser' }
          let(:password) { 'badpassword' }
        end
      end

      context 'with no credentials' do 
        it_behaves_like 'a GET request without credentials'
      end

      context 'nonexistent organization' do 
        it 'returns status 404' do 
          Organization[100].try(:destroy)
          authorize_with FactoryGirl.create(:admin)
          get '/organizations/100'
          expect(last_response.status).to eql 404
        end
      end
    end

    context 'all organizations' do 
      let(:path) { '/organizations' }
      let(:resource) { Organization.all }

      before(:each) do 
        FactoryGirl.create_list(:organization, 3)
      end

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { FactoryGirl.create(:admin) }
        end
      end

      context 'with user authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { FactoryGirl.create(:user) }
        end
      end

      context 'with invalid authorization' do 
        it_behaves_like 'an unauthorized GET request' do
          let(:username) { 'baduser' }
          let(:password) { 'badpassword' }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials'
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

    context 'nonexistent organization' do 
      it 'returns status 404' do
        Organization[100].try(:destroy)
        authorize_with FactoryGirl.create(:admin)
        put '/organizations/100', valid_attributes, 'CONTENT_TYPE' => 'application/json'
        expect(last_response.status).to eql 404
      end
    end
  end

  describe 'DELETE' do 
    let(:path) { "/organizations/#{org.id}" }
    let(:nonexistent_resource_path) { "/organizations/8372311" }

    context 'with admin authorization' do
      it_behaves_like 'an authorized DELETE request' do 
        let(:agent) { FactoryGirl.create(:admin) }
      end
    end
  end
end