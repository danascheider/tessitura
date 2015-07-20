Sequel.migration do 
  up do
    alter_table :users do 
      add_foreign_key :fach_id, :fachs
    end
  end

  down do 
    alter_table :users do 
      drop_foreign_key :fach_id
    end
  end
end
