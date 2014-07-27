class AddTitleToTaskLists < ActiveRecord::Migration
  def change
    add_column :task_lists, :title, :string
  end
end
