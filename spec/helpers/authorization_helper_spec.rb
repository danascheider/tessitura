require 'spec_helper'

describe Canto::AuthorizationHelper do 
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
  end
end