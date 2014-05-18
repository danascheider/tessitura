require 'active_record'
require 'logger'
require 'database_cleaner'
require 'factory_girl'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.expand_path('../../../db/test.sqlite3', __FILE__)
  )