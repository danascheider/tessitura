Sequel.migration do 
  up do
    alter_table :listings do 
      drop_column :program_start_date
      drop_column :program_end_date
      drop_column :deadline
      drop_column :stale
    end
  end

  down do 
    alter_table :listings do 
      add_column :program_start_date, Date
      add_column :program_end_date, Date
      add_column :deadline, Date 
      add_column :stale, FalseClass
    end
  end
end
