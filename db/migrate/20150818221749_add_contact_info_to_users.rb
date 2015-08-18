Sequel.migration do 
  up do
    alter_table :users do 
      add_column :address_1, String
      add_column :address_2, String
      add_column :state, String
      add_column :zip, Integer
    end
  end

  down do 
    alter_table :users do 
      drop_column :address_1
      drop_column :address_2
      drop_column :state
      drop_column :zip
    end
  end
end
