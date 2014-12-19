Sequel.migration do 
  up do
    add_column :listings, :stale, FalseClass
  end

  down do 
    drop_column :listings, :stale
  end
end
