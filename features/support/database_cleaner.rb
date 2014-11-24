Around do |scenario, block|
  Sequel::DATABASES.first.transaction(rollback: :always) do 
    block.call
  end
end