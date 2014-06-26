class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |table|
      table.string :title
      table.boolean :complete
      table.timestamps
    end
  end
end
