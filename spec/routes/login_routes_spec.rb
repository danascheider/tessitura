require 'spec_helper'

describe Canto do 
  include Sinatra::ErrorHandling
  include Rack::Test::Methods

  describe 'login route' do 
    context 'when user exists' do 
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do 
        authorize_with user 
        post '/login', '{}'
      end

      it 'returns the user\'s ID' do 
        expect(last_response.body).to include user.to_json
      end

      it 'returns a JSON object' do 
        expect{ JSON.parse(last_response.body) }.not_to raise_error
      end
    end

    context 'when the user doesn\'t exist' do 
      it 'returns status 401' do 
        authorize 'foo', 'bar'
        post '/login'
        expect(last_response.status).to eql 401
      end
    end

    context 'bad credentials' do 
      let(:user) { FactoryGirl.create(:user) }
      it 'returns status 401' do 
        authorize user.username, 'foobar22'
        post '/login'
        expect(last_response.status).to eql 401
      end
    end
  end
end