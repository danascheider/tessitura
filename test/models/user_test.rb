require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "invalid without a username" do 
    u = User.new 
    assert !u.valid?, "User is valid without a username"
  end
end
