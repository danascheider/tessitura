Sequel.migration do 
  up do
    alter_table(:tasks) do 
      add_column :position, Integer
      add_index :position
    end
  end

  down do 
    drop_column :tasks, :position
  end
end
