Sequel.migration do 
  up do
    alter_table :programs do 
      add_primary_key :id
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
    end
  end

  down do 
    drop_column :programs, :id
    drop_column :programs, :created_at
    drop_column :programs, :updated_at
  end
end
