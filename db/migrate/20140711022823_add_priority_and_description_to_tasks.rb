class AddPriorityAndDescriptionToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :priority, :string, default: 'normal'
    add_column :tasks, :description, :text
  end
end
