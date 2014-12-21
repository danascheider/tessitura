require 'spec_helper'

describe Canto do 
  include Sinatra::ErrorHandling
  include Rack::Test::Methods

  let(:valid_attributes) {
    {
      title: 'Super Awesome Young Artist Program',
    }
  }

  let(:invalid_attributes) {
    {
      season_id: 1
    }
  }

  describe 'POST' do 
    context 'with valid attributes' do 
      before(:each) do 
        @season = FactoryGirl.create(:season)
        @attrs = valid_attributes
        @attrs[:season_id] = @season.id
      end

      it 'calls the listing ::create method' do 
        expect(Listing).to receive(:create).with(@attrs)
        post '/listings', @attrs.to_json, 'CONTENT-TYPE' => 'application/json'
      end

      it 'returns status 201' do 
        post '/listings', @attrs.to_json, 'CONTENT-TYPE' => 'application/json'
        expect(last_response.status).to eql 201
      end
    end

    context 'with invalid attributes' do 
      before(:each) do 
        @attrs = invalid_attributes
      end

      it 'attempts to create the listing' do 
        expect(Listing).to receive(:create).with(@attrs)
        post '/listings', invalid_attributes.to_json, 'CONTENT-TYPE' => 'application/json'
      end

      it 'returns status 422' do 
        post '/listings', invalid_attributes.to_json, 'CONTENT-TYPE' => 'application/json'
        expect(last_response.status).to eql(422)
      end
    end
  end
end