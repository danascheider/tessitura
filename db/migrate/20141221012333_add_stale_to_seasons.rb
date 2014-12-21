Sequel.migration do 
  up do
    add_column :seasons, :stale, FalseClass
  end

  down do 
    drop_column :seasons, :stale
  end
end
