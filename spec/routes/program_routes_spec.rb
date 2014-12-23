require 'spec_helper'

describe Canto, programs: true do 
  include Sinatra::ErrorHandling

  let(:program) { FactoryGirl.create(:program) }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user) }
  let(:org) { program.organization }
  let(:valid_attributes) { {name: 'Merola Program'}.to_json }
  let(:final_valid_attrs) { {name: 'Merola Program', organization_id: org.id } }
  let(:invalid_attributes) { {name: nil, city: 'San Francisco'}.to_json }
  let(:final_invalid_attrs) { {name: nil, city: 'San Francisco', organization_id: org.id} }

  # NOTE: Program routes cannot be tested with the shared POST route examples
  #       because `:organization_id` is added to the request body inside the
  #       route handler before the object is created. Since the POST route
  #       examples stipulate that `#try_rescue(:create)` be called with the
  #       same attributes sent in the request, this is not practicable.

  describe 'POST' do 
    let(:path) { "organizations/#{org.id}/programs" }

    context 'with admin authorization' do 
      before(:each) do 
        authorize_with admin
      end

      context 'valid_attributes' do 
        it 'creates the program' do 
          expect(Program).to receive(:try_rescue).with(:create, final_valid_attrs)
          post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
        end

        it 'returns the program as a JSON object' do 
          post path, valid_attributes, 'CONTENT_TYPE' => 'application/json' 
          expect(last_response.body).to eql Program.last.to_json
        end

        it 'returns status 201' do 
          post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.status).to eql 201
        end
      end

      context 'invalid attributes' do 
        it 'tries to create the program' do 
          expect(Program).to receive(:try_rescue).with(:create, final_invalid_attrs)
          post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
        end

        it 'doesn\'t return program data' do 
          post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.body).to be_blank
        end

        it 'returns status 422' do 
          post path, invalid_attributes, 'CONTENT_TYPE' => 'application/json'
          expect(last_response.status).to eql 422
        end
      end
    end

    context 'with user authorization' do 
      before(:each) do 
        authorize_with user
        post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
      end

      it 'returns status 401' do 
        expect(last_response.status).to eql 401
      end

      it 'doesn\'t return any data' do 
        expect(last_response.body).to be_in([nil, 'null', '', [], {}, "Authorization Required\n", 'Authorization Required'])
      end
    end

    context 'with invalid authorization' do 
      before(:each) do 
        authorize 'notauser', 'maliciouscarol'
        post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
      end

      it 'doesn\'t return any data' do 
        expect(last_response.body).to be_in([nil, 'null', '', [], {}, "Authorization Required\n", 'Authorization Required'])
      end

      it 'returns status 401' do 
        expect(last_response.status).to eql 401
      end
    end

    context 'with no authorization' do 
      before(:each) do 
        post path, valid_attributes, 'CONTENT_TYPE' => 'application/json'
      end

      it 'doesn\'t return any data' do 
        expect(last_response.body).to be_in([nil, 'null', '', [], {}, "Authorization Required\n", 'Authorization Required'])
      end

      it 'returns status 401' do 
        expect(last_response.status).to eql 401
      end
    end
  end

  describe 'GET' do 
    context 'single program' do 
      let(:path) { "/programs/#{program.id}" }
      let(:resource) { program }

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { admin }
          let(:resource) { program }
        end
      end

      context 'with user authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { user }
          let(:resource) { program }
        end
      end

      context 'with invalid authorization' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:username) { 'badperson' }
          let(:password) { 'malicious 666' }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials'
      end
    end

    context 'programs by organization' do 
      let(:programs) { FactoryGirl.create_list(:program, 2, organization: org) }
      let(:path) { "/organizations/#{org.id}/programs" }
      let(:organizations) { FactoryGirl.create_list(:organization_with_everything, 3) }
      let(:org) { organizations.first }
      let(:resource) { org.programs }

      context 'with admin authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { admin }
        end
      end

      context 'with user authorization' do 
        it_behaves_like 'an authorized GET request' do 
          let(:agent) { user }
        end
      end

      context 'with invalid authorization' do 
        it_behaves_like 'an unauthorized GET request' do 
          let(:username) { 'hamburglar21' }
          let(:password) { 'iwanttoseeyourprogramsforfree' }
        end
      end

      context 'with no authorization' do 
        it_behaves_like 'a GET request without credentials'
      end
    end
  end
end