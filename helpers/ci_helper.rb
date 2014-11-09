module Sinatra
  module CIHelper
    def database_string
      normal = "mysql2://canto:#{DB_PASSWORD}@127.0.0.1:3306/#{ENVIRONMENT}"
      travis = "mysql2://travis@127.0.0.1:3306/test"
      return ENV['TRAVIS'] ? travis : normal
    end
  end
end