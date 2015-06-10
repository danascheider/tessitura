require 'spec_helper'

describe Tessitura, oauth2: true do 
  include Rack::Test::Methods

  let(:app) { Tessitura.new }

  let(:oauth_config) {
    path = File.expand_path '../../../oauth2/calendar.rb-oauth2.json', __FILE__
    JSON.parse(File.read(path))['web']
  }

  let(:client) {
    client = Google::APIClient.new(application_name: 'Tessitura', application_version: TessituraPackage::Version::STRING)
    client.authorization.client_id = oauth_config['client_id']
    client.authorization.client_secret = oauth_config['client_secret']
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
    client
  }

  let(:oauth2_credentials) {
    class Rack::Test::Session 
      def inject aggregator, &block; end
    end

    session = current_session
    auth = client.authorization.dup
    auth.redirect_uri = 'https://api.tessitura.io/oauth2callback'
    auth.update_token!(session)
    auth
  }

  describe '/oauth2authorize' do 
    it 'requests authorization' do 
      app = Tessitura.new;
      expect_any_instance_of(Tessitura).to receive(:redirect).with(oauth2_credentials.authorization_uri.to_s, any_args)
      get '/oauth2authorize'
    end

    it 'returns status 303' do 
      get '/oauth2authorize'
      expect(last_response.status).to equal 303
    end
  end
end