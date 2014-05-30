require 'database_cleaner' 

Before do 
  DatabaseCleaner.strategy = :truncation
end

After do 
  DatabaseCleaner.start
end