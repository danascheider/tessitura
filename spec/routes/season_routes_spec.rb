require 'spec_helper'

describe Canto, seasons: true do 
  let(:program) { FactoryGirl.create(:program_with_season) }
  let(:season) { program.seasons.first }
  let(:responses) { [nil, 'null', "Authorization Required\n", "Authorization Required", [], {}, ''] }
  let(:valid_json) { {start_date: Date.new(2015,06,17)}.to_json }
  let(:valid_hash) { {start_date: '2015-06-17', program_id: program.id } }
  let(:invalid_json) { {program_id: nil} }


  describe 'POST' do 
    let(:path) { "/programs/#{program.id}/seasons" }

    context 'with admin authorization' do 
      let(:make_request) {
        authorize_with FactoryGirl.create(:admin)
        post path, valid_json, 'CONTENT_TYPE' => 'application/json'
      }

      context 'valid attributes' do 
        it 'creates the season' do 
          expect(Season).to receive(:create).with(valid_hash)
          make_request
        end

        it 'returns the season data' do 
          make_request
          expect(last_response.body).to eql Season.last.to_json
        end

        it 'returns status 201' do 
          make_request
          expect(last_response.status).to eql 201
        end
      end

      context 'invalid program ID' do 

        # `wrong_program` definition ensures the ID is corrected for the season
        # model even if a program with the bad ID exists

        let(:make_request) {
          authorize_with FactoryGirl.create(:admin)
          wrong_program = FactoryGirl.create(:program)
          post path, {:program_id => wrong_program.id}.to_json, 'CONTENT_TYPE' => 'application/json'
        }

        it 'silently corrects the program ID' do 
          expect(Season).to receive(:create).with({:program_id => program.id})
          make_request
        end

        it 'returns the season data' do 
          make_request
          expect(last_response.body).to eql Season.last.to_json
        end

        it 'returns status 201' do 
          make_request
          expect(last_response.status).to eql 201
        end
      end
    end

    context 'with user authorization' do 
      it_behaves_like 'an unauthorized POST request' do 
        let(:agent) { FactoryGirl.create(:user) }
        let(:model) { Season }
        let(:valid_attributes) { valid_json }
      end
    end

    context 'with invalid authorization' do 
      let(:make_request) {
        authorize 'baduser', 'malicious666'
        post path, valid_json, 'CONTENT_TYPE' => 'application/json'
      }

      it 'doesn\'t create a resource' do 
        expect(Season).not_to receive(:create)
        make_request
      end

      it 'doesn\'t return data' do 
        make_request
        expect(last_response.body).to be_in(responses)
      end

      it 'returns status 401' do 
        make_request
        expect(last_response.status).to eql 401
      end
    end

    context 'with no authorization' do 
      let(:make_request) { post path, valid_json, 'CONTENT_TYPE' => 'application/json' }

      it 'doesn\'t create a season' do 
        expect(Season).not_to receive(:create)
        make_request
      end

      it 'doesn\'t return any data' do 
        make_request
        expect(last_response.body).to be_in(responses)
      end

      it 'returns status 401' do 
        make_request
        expect(last_response.status).to eql 401
      end
    end
  end

  describe 'GET' do 
    context 'single season' do 
      let(:path) { "/seasons/#{season.id}" }
      let(:resource) { season }

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
          let(:username) { 'baddymcbadderson' }
          let(:password) { 'mwahahahaha' }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials'
      end
    end
  end
end