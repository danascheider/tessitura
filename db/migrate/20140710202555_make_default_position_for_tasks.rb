class MakeDefaultPositionForTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :position, :integer, default: 1
  end
end
