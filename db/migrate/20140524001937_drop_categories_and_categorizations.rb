class DropCategoriesAndCategorizations < ActiveRecord::Migration
  def up
    drop_table :categories 
    drop_table :categorizations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
