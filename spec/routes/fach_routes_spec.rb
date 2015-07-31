require 'spec_helper'

describe Tessitura do 
  include Rack::Test::Methods

  describe 'GET' do 
    describe 'collection route' do 
      let(:path) { '/fachs' }

      it 'returns all fachs' do 
        fachs = FactoryGirl.create_list(:fach, 4)
        get path, 'CONTENT-TYPE' => 'application/json'
        expect(last_response.body).to eq Fach.all.to_json
      end
    end

    describe 'single fach route' do 
      context 'when the fach exists' do 
        it 'returns the fach' do 
          fach = FactoryGirl.create(:fach)
          get "/fachs/#{fach.id}"
          expect(last_response.body).to eq fach.to_json
        end
      end

      context 'when the fach does not exist' do 
        it 'returns 404' do 
          get '/fachs/42'
          expect(last_response.status).to eq 404
        end
      end
    end
  end
end