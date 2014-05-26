require "spec_helper"

describe User do 
  describe 'validating a user' do 
    before do 
      @user = User.new
    end

    it "is invalid without a username" do 
      @user.password = 'mypasswd1'
      @user.email = 'frank@example.com'
      expect(@user).not_to be_valid
    end

    it "is invalid without a password" do 
      @user.username = 'frank'
      @user.email = 'frank@example.com'
      expect(@user).not_to be_valid
    end

    it "is invalid without an e-mail" do 
      @user.username = 'frank'
      @user.password = 'mypasswd1'
      expect(@user).not_to be_valid
    end
  end
end