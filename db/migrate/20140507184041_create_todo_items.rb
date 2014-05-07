class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :title
      t.string :status
      t.string :priority
      t.datetime :deadline
      t.text :description

      t.timestamps
    end
  end
end
