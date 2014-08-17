class AddAncestryToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :ancestry, :string
  end
end
