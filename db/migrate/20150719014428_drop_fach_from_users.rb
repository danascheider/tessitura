Sequel.migration do 
  up do
    drop_column :users, :fach
  end

  down do 
    add_column :users, :fach, String
  end
end
