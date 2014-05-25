require 'test_helper'

class TodoItemTest < ActiveSupport::TestCase
  test "invalid without a title" do 
    t = TodoItem.new 
    assert !t.valid?
  end
end
