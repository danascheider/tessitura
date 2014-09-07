Sequel.migration do 
  up do
    create_table(:users) do 
      primary_key :id
      string      :username
      string      :password
      string      :email
      string      :first_name
      string      :last_name
      string      :city
      string      :country
      string      :fach
      date        :birthdate
      boolean     :admin
      timestamp   :created_at
      timestamp   :updated_at
    end
  end

  down do 
    drop_table(:users)
  end
end
