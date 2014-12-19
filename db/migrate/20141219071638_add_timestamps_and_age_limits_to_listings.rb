Sequel.migration do 
  up do
    alter_table :listings do 
      add_column :created_at, DateTime
      add_column :updated_at, DateTime
      add_column :min_age, Integer
      add_column :max_age, Integer
    end
  end

  down do 
    alter_table :listings do 
      drop_column :created_at
      drop_column :updated_at
      drop_column :min_age
      drop_column :max_age
    end
  end
end
