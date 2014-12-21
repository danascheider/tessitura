Sequel.migration do 
  up do
    create_table :programs_users do 
      foreign_key :program_id, :programs 
      foreign_key :user_id, :users
    end
  end

  down do 
    drop_table :programs_users
  end
end
