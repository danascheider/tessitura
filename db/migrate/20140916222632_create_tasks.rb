Sequel.migration do 
  up do
    create_table(:tasks) do 
      primary_key :id
      foreign_key :task_list_id, :task_lists, null: false
      String      :title, null: false
      String      :status, default: 'new', null: false
      String      :priority, default: 'normal', null: false
      DateTime    :deadline
      String      :description, text: true
      Integer     :owner_id, null: false
      DateTime    :created_at
      DateTime    :updated_at
    end
  end

  down do 
    drop_table(:tasks)
  end
end
