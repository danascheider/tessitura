Sequel.migration do 
  up do
    create_table :programs do 
      foreign_key :organization_id
      String :type
      Integer :min_age
      Integer :max_age
      String :website
      String :contact_name
      String :contact_phone
      String :contact_email
    end
  end

  down do 
    drop_table :programs
  end
end
