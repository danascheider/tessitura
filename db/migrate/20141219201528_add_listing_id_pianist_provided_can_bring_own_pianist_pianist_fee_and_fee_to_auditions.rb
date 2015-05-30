Sequel.migration do 
  up do
    alter_table :auditions do 
      add_column :listing_id, Integer
      add_column :pianist_provided, FalseClass
      add_column :can_bring_own_pianist, FalseClass
      add_column :pianist_fee, Float
      add_column :fee, Float
    end
  end

  down do 
    alter_table :auditions do 
      drop_column :listing_id
      drop_column :pianist_provided
      drop_column :can_bring_own_pianist
      drop_column :pianist_fee
      drop_column :fee
    end
  end
end
