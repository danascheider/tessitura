require 'spec_helper'

describe Tessitura, churches: true do 
  include Sinatra::ErrorHandling

  let(:church) { FactoryGirl.create(:church) }
  let(:model) { Church }
  let(:valid_attributes) { { name: 'Immaculate Heart Catholic Church' }.to_json }
  let(:invalid_attributes) { { postal_code: 97206 }.to_json }

  describe 'POST' do 
    let(:path) { '/churches' }

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
    context 'individual church' do 
      let(:path) { "/churches/#{church.id}" }
      let(:resource) { church }

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

      context 'nonexistent church' do 
        it 'returns status 404' do 
          Church[100].try(:destroy)
          authorize_with FactoryGirl.create(:admin)
          get '/churches/100'
          expect(last_response.status).to eql 404
        end
      end
    end

    context 'all churches' do 
      let(:path) { '/churches' }
      let(:resource) { Church.all }

      before(:each) do 
        FactoryGirl.create_list(:church, 3)
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

  describe 'DELETE' do 
    let(:path) { "/churches/#{church.id}" }
    let(:nonexistent_resource_path) { "/churches/8372311" }

    context 'with admin authorization' do
      it_behaves_like 'an authorized DELETE request' do 
        let(:agent) { FactoryGirl.create(:admin) }
      end
    end

    context 'with user authorization' do 
      it_behaves_like 'an unauthorized DELETE request' do 
        let(:agent) { FactoryGirl.create(:user) }
      end
    end
  end
end