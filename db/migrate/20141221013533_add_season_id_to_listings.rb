Sequel.migration do 
  up do
    alter_table :listings do 
      add_foreign_key :season_id, :seasons
    end
  end

  down do 
    alter_table :listings do 
      drop_foreign_key :season_id
    end
  end
end
