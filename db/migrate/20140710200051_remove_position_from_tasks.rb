class RemovePositionFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :position
  end
end
