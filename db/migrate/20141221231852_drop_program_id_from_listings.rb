Sequel.migration do 
  up do
    alter_table :listings do 
      drop_foreign_key :program_id
    end
  end

  down do 
    alter_table :listings do  
      add_foreign_key :program_id, :programs
    end
  end
end
