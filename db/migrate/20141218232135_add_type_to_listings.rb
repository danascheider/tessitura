Sequel.migration do 
  up do
    add_column :listings, :type, String
  end

  down do 
    drop_column :listings, :type
  end
end
