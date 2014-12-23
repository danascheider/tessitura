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
      end
    end
  end
end