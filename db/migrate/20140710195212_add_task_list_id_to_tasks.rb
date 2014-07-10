class AddTaskListIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :task_list_id, :integer
  end
end
