Sequel.migration do 
  up do
    drop_table :listings_users
  end

  down do 
    create_table :listings_users do 
      foreign_key :listing_id, :listings 
      foreign_key :user_id, :users
    end
  end
end
