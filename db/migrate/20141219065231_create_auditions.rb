Sequel.migration do 
  up do
    create_table :auditions do 
      primary_key :id
      String :country
      String :region
      String :city
      Date :date
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do 
    drop_table :auditions
  end
end
