Sequel.migration do 
  up do
    alter_table(:users) do 
      add_unique_constraint(:username)
    end
  end

  down do 
    alter_table(:users) do 
      drop_unique_constraint(:username)
    end
  end
end
