class RemoveIndexFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :index
  end
end
