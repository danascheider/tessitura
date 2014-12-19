Sequel.migration do 
  up do
    create_table :listings_users do 
      foreign_key :listing_id, :listings 
      foreign_key :user_id, :users
    end
  end

  down do 
    drop_table :listings_users
  end
end
