Sequel.migration do 
  up do
    create_table :users do 
      primary_key :id
      String     :username
      String     :password
      String     :email
      Date       :birthdate
      String     :city
      String     :country
      String     :fach
      FalseClass :admin
      DateTime   :created_at
      DateTime   :updated_at
    end
  end

  down do
    drop_table :users
  end
end
