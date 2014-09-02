require 'sequel'

DB = Sequel.sqlite3

DB.create_table :users do 
  primary_key :id
  String :username
  String :password
  String :email
  String :first_name
  String :last_name
end