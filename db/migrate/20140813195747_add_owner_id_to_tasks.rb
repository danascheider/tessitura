class AddOwnerIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :owner_id, :integer
  end
end
