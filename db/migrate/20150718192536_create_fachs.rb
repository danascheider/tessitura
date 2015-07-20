Sequel.migration do 
  up do
    create_table :fachs do
      String :type
      String :quality
      FalseClass :coloratura
    end
  end

  down do 
    drop_table :fachs
  end
end
