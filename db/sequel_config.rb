require 'sequel'

DB_DIR = File.expand_path('..', __FILE__)
environment = ENV['RACK_ENV'] || 'development'

DB = Sequel.sqlite("./#{environment}.sqlite3")

DB.create_table :users do 
  primary_key :id
  String :username
  String :password
  String :email
  String :first_name
  String :last_name
end