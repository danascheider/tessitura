Sequel.migration do 
  up do
    alter_table :organizations do
      add_column :type, String
    end
  end

  down do 
    alter_table :organizations do 
      drop_column :type
    end
  end
end
