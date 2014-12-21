Sequel.migration do 
  up do
    alter_table :listings do 
      drop_column :web_site
      drop_column :type
      drop_column :country
      drop_column :region
      drop_column :city
      drop_column :max_age
      drop_column :min_age
      drop_column :organization
    end
  end

  down do 
    alter_table :listings do 
      add_column :web_site, String
      add_column :type, String
      add_column :country, String
      add_column :region, String
      add_column :city, String
      add_column :max_age, String
      add_column :min_age, String
      add_column :organization, String
    end
  end
end
