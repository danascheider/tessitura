Sequel.migration do 
  up do
    alter_table :organizations do 
      add_primary_key :id
    end
  end

  down do 
    drop_column :organizations, :id
  end
end
