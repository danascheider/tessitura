Sequel.migration do 
  up do
    alter_table :programs do 
      add_column :name, String
      add_column :country, String
      add_column :region, String
      add_column :city, String
    end
  end

  down do 
    alter_table :programs do 
      drop_column :name
      drop_column :country
      drop_column :region
      drop_column :city
    end
  end
end
