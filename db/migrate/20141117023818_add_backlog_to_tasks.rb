Sequel.migration do 
  up do
    add_column :tasks, :backlog, FalseClass
  end

  down do 
    drop_column :tasks, :backlog
  end
end
