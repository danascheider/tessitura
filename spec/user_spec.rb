require "spec_helper"

describe User do 
  it "is invalid without a username" do 
    user = User.new
    expect(user).not_to be_valid
  end

  it "is invalid without a password" do 
    user = FactoryGirl.create(:user, password: nil)
    expect(user).not_to be_valid
  end
end