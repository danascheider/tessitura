Sequel.migration do 
  up do
    alter_table :listings do 
      add_foreign_key :program_id, :programs
    end
  end

  down do 
    drop_column :listings, :program_id
  end
end
