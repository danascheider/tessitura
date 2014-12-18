Sequel.migration do 
  up do
    create_table(:listings) do 
      primary_key :id
      String      :title, null: false
      String      :web_site, null: false
      String      :country, null: false
      String      :region
      String      :city, null: false
      Date        :deadline
      Date        :program_start_date, null: false
      Date        :program_end_date
      String      :organization
    end
  end

  down do 
    drop_table(:listings)
  end
end
