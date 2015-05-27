require 'spec_helper'

describe Tessitura, seasons: true do 
  include Sinatra::ErrorHandling

  let(:program) { FactoryGirl.create(:program_with_season) }
  let(:season) { program.seasons.first }
  let(:responses) { [nil, 'null', "Authorization Required\n", "Authorization Required", [], {}, ''] }
  let(:valid_json) { {start_date: Date.new(2015,06,17)}.to_json }
  let(:valid_hash) { {start_date: '2015-06-17', program_id: program.id } }
  let(:invalid_json) { {program_id: nil}.to_json }


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

    context 'single program\'s fresh seasons' do 
      let(:program) { FactoryGirl.create(:program_with_everything) }
      let(:resource) { Season.where(program_id: program.id).exclude(stale: true) }
      let(:path) { "/programs/#{program.id}/seasons" }

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
        it_behaves_like 'a GET request without credentials' do 
          let(:username) { 'baddymcbadderson' }
          let(:password) { 'malicious666' }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials'
      end
    end

    context 'all seasons of a program' do 
      let(:program) { FactoryGirl.create(:program_with_everything) }
      let(:path) { "/programs/#{program.id}/seasons/all" }
      let(:resource) { program.seasons }

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
          let(:password) { "I'm a baddie" }
        end
      end

      context 'with no credentials' do 
        it_behaves_like 'a GET request without credentials'
      end
    end
  end

  describe 'PUT' do 
    let(:path) { "/seasons/#{season.id}" }
    let(:resource) { season }

    context 'with admin authorization' do 
      context 'with valid attributes' do 
        let(:make_request) {
          authorize_with FactoryGirl.create(:admin)
          put path, valid_json, 'CONTENT_TYPE' => 'application/json'
        }

        it 'updates the season' do 
          expect_any_instance_of(Season).to receive(:update).with({start_date: '2015-06-17'})
          make_request
        end

        it 'returns status 200' do 
          make_request
          expect(last_response.status).to eql 200
        end
      end

      context 'with invalid attributes' do 
        let(:make_request) {
          authorize_with FactoryGirl.create(:admin)
          put path, invalid_json, 'CONTENT_TYPE' => 'application/json'
        }

        it 'attempts to update the season' do 
          expect_any_instance_of(Season).to receive(:update).with({program_id: nil})
          make_request
        end

        it 'returns status 422' do 
          make_request
          expect(last_response.status).to eql 422
        end
      end
    end

    context 'with user authorization' do
      it_behaves_like 'an unauthorized PUT request' do 
        let(:agent) { FactoryGirl.create(:user) }
        let(:model) { Season }
        let(:valid_attributes) { valid_json }
      end
    end

    context 'with invalid authorization' do 
      it_behaves_like 'an unauthorized PUT request' do 
        let(:agent) { FactoryGirl.build(:user, username: 'foo', password: 'bar')}
        let(:model) { Season }
        let(:valid_attributes) { valid_json }
      end
    end

    context 'with no authorization' do 
      let(:make_request) { put path, valid_json, 'CONTENT_TYPE' => 'application/json' }

      it 'doesn\'t update the season' do 
        expect_any_instance_of(Season).not_to receive(:update)
        make_request
      end

      it 'returns status 401' do 
        make_request
        expect(last_response.status).to eql 401
      end
    end
  end

  describe 'DELETE' do 
    let(:path) { "/seasons/#{season.id}" }
    let(:resource) { season }
    let(:model) { Season }
    let(:nonexistent_resource_path) { "/seasons/1000388328854" }

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

    context 'with invalid credentials' do 
      it_behaves_like 'an unauthorized DELETE request' do 
        let(:agent) { FactoryGirl.build(:user, username: 'foo', password: 'bar') }
      end
    end

    context 'with no authorization' do 
      it_behaves_like 'a DELETE request without credentials'
    end
  end
end