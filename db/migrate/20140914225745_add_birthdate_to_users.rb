Sequel.migration do 
  up do
    add_column :users, :birthdate, Date
  end

  down do 
    drop_column :users, :birthdate
  end
end
