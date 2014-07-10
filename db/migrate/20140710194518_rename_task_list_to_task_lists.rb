class RenameTaskListToTaskLists < ActiveRecord::Migration
  def change
    rename_table :task_list, :task_lists
  end
end
