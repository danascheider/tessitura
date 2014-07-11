class MakeDefaultTaskStatus < ActiveRecord::Migration
  def change
    change_column :tasks, :status, :string, default: 'new'
  end
end
