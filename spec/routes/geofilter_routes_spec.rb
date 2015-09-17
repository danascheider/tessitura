require 'spec_helper'

describe Tessitura, geofilter: true do 
  include Rack::Test::Methods
  include Sinatra::ErrorHandling

  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }
  let(:path) { '/geofilter' }

  describe 'POST' do 
    let(:body) { {state: 'OR'}.to_json }

    before(:each) do 
      @organizations = FactoryGirl.create_list(:organization, 3)
    end

    it 'instantiates a GeoFilter object' do 
      filter = double('geofilter').as_null_object
      expect(GeoFilter).to receive(:new).with(Organization, {state: 'OR'}).and_return(filter)
      post path, body, 'CONTENT_TYPE' => 'application/json'
    end

    it 'returns only the matching organization' do 
      Organization.last.update(state: 'OR')
      post path, body, 'CONTENT_TYPE' => 'application/json'
      expect(last_response.body).to eql [Organization.last].to_json
    end
  end
end