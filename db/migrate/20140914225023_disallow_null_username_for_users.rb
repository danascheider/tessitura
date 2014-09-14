Sequel.migration do 
  up do
    alter_table(:users) do 
      set_column_not_null(:username)
    end
  end

  down do 
    alter_table(:users) do 
      set_column_allow_null(:username)
    end
  end
end
