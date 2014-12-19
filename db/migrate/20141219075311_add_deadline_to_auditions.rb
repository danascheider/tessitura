Sequel.migration do 
  up do
    add_column :auditions, :deadline, Date
  end

  down do 
    drop_column :auditions, :deadline
  end
end
