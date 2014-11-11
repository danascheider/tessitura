require 'spec_helper'
require 'base64'

# There is a scoping issue causing problems with testing this module. Specifically,
# when authentication fails via the ::protect and ::admin_only! methods, the call to 
# ::headers triggers a NoMethodError.

# More information: https://github.com/danascheider/canto/issues/46

describe Sinatra::AuthorizationHelper do 
  include Rack::Test::Methods
  include Sinatra::Helpers
  include Sinatra::AuthorizationHelper

  let(:admin) { FactoryGirl.create(:admin) }
  let(:user) { FactoryGirl.create(:user_with_task_lists) }
  let(:task) { user.tasks.first } 
  let(:admin_credentials) { Base64.encode64("#{admin.username}:#{admin.password}") }
  let(:user_credentials) { Base64.encode64("#{user.username}:#{user.password}") }
  let(:bogus_credentials) { Base64.encode64('foo:bar') }
  
  before(:each) do 
    @env1 = { "HTTP_AUTHORIZATION" => "Basic #{admin_credentials}" }
    @env2 = { "HTTP_AUTHORIZATION" => "Basic #{user_credentials}" }
    @env3 = { "HTTP_AUTHORIZATION" => "Basic #{bogus_credentials}" }
  end

  # ::admin_only! and ::protect methods return nil if authorization is successful;
  # otherwise, they return status code 401 and WWW-Authorization headers

  describe '::admin_only!' do 
    context 'when user is an admin' do 
      it 'allows access to the resource' do 
        @auth = Rack::Auth::Basic::Request.new(@env1)
        expect(admin_only!).to eql nil
      end
    end

    context 'when logged-in user is not an admin' do 
      it 'doesn\'t allow access to the resource' do 
        @auth = Rack::Auth::Basic::Request.new(@env2)
        get '/test/admin_only'
        expect(last_response.body).to eql "Authorization Required\n"
      end
    end

    context 'when not logged in' do 
      it 'doesn\'t allow access to the resource' do 
        get '/test/admin_only'
        expect(last_response.body).to eql "Authorization Required\n"
      end
    end
  end

  describe '::access_denied' do 
    before(:each) do 
      get '/test/access_denied'
    end

    it 'sets the WWW-Authenticate header' do 
      expect(last_response.headers['WWW-Authenticate']).to eql 'Basic realm="Restricted Area"'
    end

    it 'returns status 401' do 
      expect(last_response.status).to eql 401
    end

    it 'halts the request' do 
      expect(last_response.body).not_to eql({ 'message' => 'Hello world' }.to_json)
    end
  end

  describe '::authorized?' do 
    context 'with proper credentials' do 
      it 'returns true' do 
        @auth = Rack::Auth::Basic::Request.new(@env2)
        expect(authorized?).to be_truthy
      end
    end

    context 'with bad credentials' do 
      it 'returns false' do 
        @auth = Rack::Auth::Basic::Request.new(@env3)
        expect(authorized?).to be_falsey
      end
    end

    context 'with no credentials' do 
      it 'returns false' do 
        @auth = Rack::Auth::Basic::Request.new({})
        expect(authorized?).to be_falsey
      end
    end
  end

  describe '::authorized_for_resource?' do 
    context 'when the logged-in user is an admin' do 
      it 'returns true' do 
        allow(@auth).to receive(:credentials).and_return([admin.username, admin.password])
        expect(authorized_for_resource?(user.id)).to be_truthy
      end
    end

    context 'when the logged-in user is the owner of the resource' do 
      it 'returns true' do 
        allow(@auth).to receive(:credentials).and_return([user.username, user.password])
        expect(authorized_for_resource?(user.id)).to be_truthy
      end
    end

    context 'when the logged-in user is not the owner of the resource' do
      it 'returns false' do 
        allow(@auth).to receive(:credentials).and_return([user.username, user.password])
        expect(authorized_for_resource?(admin.id)).to be_falsey
      end

      it 'doesn\'t let a user set admin' do
        allow(@auth).to receive(:credentials).and_return([user.username, user.password])
        stub(:setting_admin?).and_return(true)
        expect(authorized_for_resource?(user.id)).to be_falsey
      end
    end
  end

  describe '::current_user' do 
    it 'returns the logged-in user' do 
      allow(@auth).to receive(:credentials).and_return([user.username, user.password])
      expect(current_user).to eql user
    end
  end

  describe '::protect' do  
    context 'when the user doesn\'t exist' do 
      it 'returns 404' do 
        @id = 1000000
        expect(protect(User)).to eql 404
      end
    end

    context 'when the user doesn\'t have access' do 
      before(:each) do 
        allow_any_instance_of(Canto).to receive(:authorized?).and_return(false)
      end

      it 'returns 401' do 
        get "/test/users/#{admin.id}"
        expect(last_response.status).to eql 401
      end

      # FIX: This sends ::access_denied two times - need to find out why
      it 'calls ::access_denied' do 
        pending('Debug')
        @id = user.id
        expect_any_instance_of(Canto).to receive(:access_denied)
        get "/test/users/#{admin.id}"
      end
    end

    context 'when the user is authorized' do 
      it 'returns nil' do 
        @auth, @id = Rack::Auth::Basic::Request.new(@env2), user.id
        expect(protect(User)).to eql nil
      end
    end
  end

  describe '::setting_admin' do 
    context 'when the request body has :admin key' do 
      it 'returns true' do 
        @request_body = { admin: true }
        expect(setting_admin?).to be_truthy
      end
    end

    context 'when the request body does not have :admin key' do 
      it 'returns false' do 
        @request_body = { 'fach' => 'dramatic coloratura' }
        expect(setting_admin?).to be_falsey
      end
    end

    context 'when there is no request body' do 
      it 'returns false' do 
        expect(setting_admin?).to be_falsey
      end
    end
  end

  describe '::valid_credentials?' do 
    context 'with valid credentials' do 
      it 'returns true' do 
        @auth = Rack::Auth::Basic::Request.new(@env2)
        expect(valid_credentials?).to be_truthy
      end
    end

    context 'with bad credentials' do 
      it 'returns false' do 
        bad_credentials = Base64.encode64("#{user.username}:badpassword")
        @auth = Rack::Auth::Basic::Request.new({ "HTTP_AUTHORIZATION" => "Basic #{bad_credentials}" })
        expect(valid_credentials?).to be_falsey
      end
    end

    context 'with no credentials' do 
      it 'returns false' do 
        @auth = Rack::Auth::Basic::Request.new({})
        expect(valid_credentials?).to be_falsey
      end
    end
  end
end