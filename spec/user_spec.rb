require "spec_helper"

describe User do 
  it "is invalid without a username" do 
    user = User.new
    expect(user).not_to be_valid
  end
end