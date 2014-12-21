Sequel.migration do 
  up do
    create_table :seasons do 
      primary_key :id
      Date :start_date
      Date :end_date 
      Date :early_bird_deadline
      Date :priority_deadline
      Date :final_deadline
      Float :payments
      Float :program_fees
      Float :peripheral_fees
      Float :application_fee
      foreign_key :program_id, :programs
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do 
    drop_table :seasons
  end
end
