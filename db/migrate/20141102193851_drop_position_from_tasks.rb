Sequel.migration do 
  up do
    drop_column :tasks, :position
  end

  down do 
    add_column :tasks, :position, Integer
  end
end
