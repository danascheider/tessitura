Sequel.migration do 
  up do
    create_table :organizations do 
      String :name
      String :address_1
      String :address_2
      String :country
      String :city
      String :region
      String :postal_code
      String :website
      String :contact_name
      String :phone_1
      String :phone_2
      String :email_1
      String :email_2
      String :fax
      String :created_at
      String :updated_at
    end
  end

  down do 
    drop_table :organizations
  end
end
