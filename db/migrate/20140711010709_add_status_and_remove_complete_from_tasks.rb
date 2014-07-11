class AddStatusAndRemoveCompleteFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :complete
    add_column :tasks, :status, :string
  end
end
