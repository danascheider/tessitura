require 'sequel'

DB_DIR = File.expand_path('..', __FILE__)
environment = ENV['RACK_ENV'] || 'development'

Sequel.extension :migration

DB = Sequel.sqlite("./#{environment}.sqlite3")