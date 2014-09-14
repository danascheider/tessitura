Sequel.migration do 
  up do
    add_column :users, :city, String
    add_column :users, :country, String
    add_column :users, :fach, String
    add_column :users, :admin, FalseClass, default: false
  end

  down do 
    drop_column :users, :city
    drop_column :users, :country
    drop_column :users, :fach 
    drop_column :users, :admin
  end
end
