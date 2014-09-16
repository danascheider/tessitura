Sequel.migration do 
  up do
    alter_table(:tasks) do 
      set_column_allow_null :task_list_id
    end
  end

  down do 
    alter_table(:tasks) do 
      set_column_not_null :task_list_id
    end
  end
end
