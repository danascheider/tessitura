database_path = File.expand_path("../../db/#{ENV['RACK_ENV']}.sqlite3")
DB = Sequel.sqlite("sqlite:///#{database_path}")
class User < Sequel::Model
end