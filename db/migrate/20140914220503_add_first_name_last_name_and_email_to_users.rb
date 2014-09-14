Sequel.migration do 
  up do
    add_column :users, :email, String
    add_column :users, :first_name, String
    add_column :users, :last_name, String
  end

  down do 
    drop_column :users, :email
    drop_column :users, :first_name
    drop_column :users, :last_name
  end
end
