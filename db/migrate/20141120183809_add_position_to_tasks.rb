Sequel.migration do 
  up do
    add_column :tasks, :position, Integer
  end

  down do 
    drop_column :tasks, :position
  end
end
