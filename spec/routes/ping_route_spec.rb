require 'spec_helper'

describe Tessitura do 
  include Sinatra::ErrorHandling
  include Sequel

  describe 'GET' do 
    let(:path) {'/ping'}

    context 'general' do 
      before(:each) do 
        get path 
      end

      it 'returns the value of ENV[\'RACK_ENV\']' do 
        expect(JSON.parse(last_response.body)['environment']).to eq(ENV['RACK_ENV'])
      end

      it 'returns the database URL' do 
        expect(JSON.parse(last_response.body)['db_url']).to eq(DB.url)
      end

      it 'doesn\'t create a new user permanently' do 
        expect { get path }.not_to change(User, :count)
      end
    end

    context 'when it works' do 
      it 'tells you the schema is current' do 
        allow(Sequel::Migrator).to receive(:is_current?).and_return(true)
        get path
        expect(JSON.parse(last_response.body)['schema_current']).to be true
      end

      it 'tells you the database is readable' do 
        user = FactoryGirl.create(:user)
        allow_any_instance_of(User).to receive(:to_hash).and_return({:foo => :bar})
        get path
        expect(JSON.parse(last_response.body)['db_readable']).to be true
      end

      it 'tells you the database is writable' do 
        allow_any_instance_of(User).to receive(:save).and_return(self)
        get path
        expect(JSON.parse(last_response.body)['db_writable']).to be true
      end
    end

    context 'when it doesn\'t work' do 
      it 'tells you the schema is not current' do 
        allow(Sequel::Migrator).to receive(:is_current?).and_return(false)
        get path
        expect(JSON.parse(last_response.body)['schema_current']).to be false
      end

      it 'tells you the database is not readable' do 
        allow(User).to receive(:first).and_return(nil)
        get path
        expect(JSON.parse(last_response.body)['db_readable']).to be false
      end

      it 'tells you the database is not writable' do 
        allow_any_instance_of(User).to receive(:save).and_return(nil)
        get path
        expect(JSON.parse(last_response.body)['db_writable']).to be false
      end
    end
    #
    # Database connection works?
    # Can read and write to the database?
    # Does the database have the right schema?
    # ENV['RACK_ENV']
    #
  end
end