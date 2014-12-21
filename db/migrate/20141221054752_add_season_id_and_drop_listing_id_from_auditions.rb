Sequel.migration do 
  up do
    alter_table :auditions do 
      drop_column :listing_id
      add_foreign_key :season_id, :seasons
    end
  end

  down do 
    alter_table :auditions do 
      add_column :listing_id
      drop_foreign_key :season_id
    end
  end
end
