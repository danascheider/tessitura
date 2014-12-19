require 'spec_helper'

describe Canto do 
  include Sinatra::ErrorHandling
  include Rack::Test::Methods

  let(:valid_attributes) {
    {
      title: 'Super Awesome Young Artist Program',
      type:  'Young Artist Program',
      web_site: 'http://www.superawesomeyap.com',
      country: 'USA',
      region: 'New York',
      city: 'New York City',
      program_start_date: Date.new(2015, 7, 3),
      program_end_date: Date.new(2015, 8, 1),
      max_age: 35
    }
  }

  let(:invalid_attributes) {
    {
      type:  'Young Artist Program',
      web_site: 'http://www.superawesomeyap.com',
      country: 'USA',
      region: 'New York',
      city: 'New York City',
      program_start_date: Date.new(2015, 7, 3),
      program_end_date: Date.new(2015, 8, 1),
      max_age: 35
    }
  }

  describe 'POST' do 
    context 'with valid attributes' do 
      before(:each) do 
        @json_attrs = valid_attributes.to_json
        @reg_attrs = valid_attributes
        @reg_attrs[:program_start_date] = @reg_attrs[:program_start_date].strftime('%Y-%m-%d')
        @reg_attrs[:program_end_date] = @reg_attrs[:program_end_date].strftime('%Y-%m-%d')
      end

      it 'calls the listing ::create method' do 
        expect(Listing).to receive(:create).with(@reg_attrs)
        post '/listings', @json_attrs, 'CONTENT-TYPE' => 'application/json'
      end

      it 'returns status 201' do 
        post '/listings', @json_attrs, 'CONTENT-TYPE' => 'application/json'
        expect(last_response.status).to eql 201
      end
    end

    context 'with invalid attributes' do 
      before(:each) do 
        @reg_attrs = invalid_attributes
        @reg_attrs[:program_start_date] = @reg_attrs[:program_start_date].strftime('%Y-%m-%d')
        @reg_attrs[:program_end_date] = @reg_attrs[:program_end_date].strftime('%Y-%m-%d')
      end

      it 'attempts to create the listing' do 
        expect(Listing).to receive(:create).with(@reg_attrs)
        post '/listings', invalid_attributes.to_json, 'CONTENT-TYPE' => 'application/json'
      end

      it 'returns status 422' do 
        post '/listings', invalid_attributes.to_json, 'CONTENT-TYPE' => 'application/json'
        expect(last_response.status).to eql(422)
      end
    end
  end
end