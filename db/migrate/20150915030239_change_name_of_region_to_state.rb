Sequel.migration do 
  up do
    alter_table :organizations do 
      rename_column :region, :state
    end
  end

  down do 
    alter_table :organizations do 
      rename_column :state, :region
    end
  end
end
