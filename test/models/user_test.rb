require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "invalid without a username" do 
    u = Factory(:user)
    assert !u.valid?, "User is valid without a username"
  end

  test "has unique username" do 
    u = Factory(:user)
    v = Factory(:user)
    assert !v.valid?, "User is valid without unique username"
  end
end
