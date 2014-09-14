Sequel.migration do 
  up do
    alter_table(:users) do 
      set_column_not_null(:password)
      set_column_not_null(:email)
    end
  end

  down do 
    alter_table(:users) do 
      set_column_allow_null(:password)
      set_column_allow_null(:email)
    end
  end
end
