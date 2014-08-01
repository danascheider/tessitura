class AddDefaultValueToTaskPriority < ActiveRecord::Migration
  def change
    change_column :tasks, :priority, :string, default: 'normal'
  end
end
