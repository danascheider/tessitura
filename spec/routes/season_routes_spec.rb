require 'spec_helper'

describe Canto, seasons: true do 
  let(:program) { FactoryGirl.create(:program_with_season) }
  let(:season) { program.seasons.first }
  let(:valid_json) { {start_date: Date.new(2015,06,17)}.to_json }
  let(:valid_hash) { {start_date: Date.new(2015,06,17), program_id: program.id } }

  describe 'POST' do 
    let(:path) { "/programs/#{program.id}/seasons" }

    context 'with admin authorization' do 
      before(:each) do 
        authorize_with FactoryGirl.create(:admin)
      end

      context 'valid attributes' do 
        it 'creates the season' do 
          expect(Season).to receive(:create).with(valid_hash)
          post path, valid_json, 'CONTENT_TYPE' => 'application/json'
        end

        it 'returns the season data' do 
          post path, valid_json, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.body).to eql Season.last.to_json
        end

        it 'returns status 201' do 
          post path, valid_json, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.status).to eql 201
        end
      end
    end
  end
end