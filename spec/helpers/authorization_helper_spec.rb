require 'spec_helper'

# There is a scoping issue causing problems with testing this module. Specifically,
# when authentication fails via the ::protect and ::admin_only! methods, the call to 
# ::headers triggers a NoMethodError.

# More information: https://github.com/danascheider/canto/issues/46

describe Canto::AuthorizationHelper do 
  include Rack::Test::Methods
  include Canto::AuthorizationHelper
  
  before(:each) do 
    @admin = FactoryGirl.create(:admin)
    @user = FactoryGirl.create(:user_with_task_lists)
    @task = Task.first

    @admin_credentials = Base64.encode64("#{@admin.username}:#{@admin.password}")
    @user_credentials = Base64.encode64("#{@user.username}:#{@user.password}")

    @ENV1 = { "HTTP_AUTHORIZATION" => "Basic #{@admin_credentials}" }
    @ENV2 = { "HTTP_AUTHORIZATION" => "Basic #{@user_credentials}" }
  end

  describe '::admin_access?' do 
    context 'when logged-in user is an admin' do 
      it 'returns true' do 
        @auth = Rack::Auth::Basic::Request.new(@ENV1)
        expect(admin_access?).to eql true
      end
    end

    context 'when logged-in user is not an admin' do 
      it 'returns false' do 
        @auth = Rack::Auth::Basic::Request.new(@ENV2)
        expect(admin_access?).to be_falsey
      end
    end
  end

  # ::admin_only! and ::protect methods return nil if authorization is successful;
  # otherwise, they return status code 401 and WWW-Authorization headers

  describe '::admin_only!' do 
    pending
    context 'when logged-in user is an admin' do 
      it 'returns nil' do 
        @auth = Rack::Auth::Basic::Request.new(@ENV1)
        expect(admin_only!).to eql nil
      end
    end

    context 'when logged-in user is not an admin' do 
    end

    context 'when not logged in' do 
    end
  end
end