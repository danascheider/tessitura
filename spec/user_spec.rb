require "spec_helper"

describe User do 
  describe 'validating a user' do 
    before do 
      @user = User.new
    end

    it "is invalid without a username" do 
      @user.password = 'mypasswd1'
      expect(@user).not_to be_valid
    end

    it "is invalid without a password" do 
      @user.username = 'frank'
      expect(@user).not_to be_valid
    end
  end
end