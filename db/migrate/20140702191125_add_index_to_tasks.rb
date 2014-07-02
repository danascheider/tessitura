class AddIndexToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :index, :integer
  end
end
