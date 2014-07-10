class AddIndexToPositionsColumnInTasks < ActiveRecord::Migration
  def change
    add_index :tasks, :position, unique: true
  end
end
