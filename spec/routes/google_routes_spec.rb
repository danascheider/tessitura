require 'spec_helper'

describe Tessitura, google: true do 
  include Rack::Test::Methods
  include Sinatra::ErrorHandling

  let(:user) { FactoryGirl.create(:user) }

  describe 'GET' do 
    it 'instantiates a Google::APIClient object' do 
      expect(Google::APIClient).to receive(:new)
      authorize_with user
      get "/users/#{user.id}/calendar"
    end
  end

  describe 'POST' do 
    it 'instantiates a google::APIClient object' do 
      #
    end
  end

  describe 'PUT' do 
    it 'instantiates a Google::APIClient object' do
    end
  end

  describe 'DELETE' do 
    it 'instantiates a Google::APIClient object' do 
      #
    end
  end
end