Sequel.migration do 
  up do
    alter_table(:tasks) do 
      set_column_allow_null :owner_id
    end
  end

  down do 
    alter_table(:tasks) do 
      set_column_not_null :owner_id
    end
  end
end
