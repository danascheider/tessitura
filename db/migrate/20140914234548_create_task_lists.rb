Sequel.migration do 
  up do
    create_table(:task_lists) do 
      primary_key :id
      foreign_key :user_id, :users
      String      :title
      DateTime    :created_at
      DateTime    :updated_at
    end
  end

  down do 
    drop_table(:task_lists)
  end
end
