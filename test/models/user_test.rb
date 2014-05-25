require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "invalid without a username" do 
    u = User.new 
    assert !u.valid?, "User is valid without a username"
  end

  test "has unique username" do 
    u = User.new(username: 'frank')
    v = User.new(username: 'frank')
    assert !v.valid?, "User is valid without unique username"
  end
end
