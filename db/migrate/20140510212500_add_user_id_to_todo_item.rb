class AddUserIdToTodoItem < ActiveRecord::Migration
  def change
    add_column :todo_items, :user_id, :integer
  end
end
