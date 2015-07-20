Sequel.migration do 
  up do
    alter_table :fachs do 
      add_primary_key :id
    end
  end

  down do 
    alter_table :fachs do 
      drop_primary_key :id
    end
  end
end
