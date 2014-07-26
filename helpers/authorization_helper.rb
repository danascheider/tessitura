class Sinatra::Application
  module AuthorizationHelper
    def authorized?(method, resource, id=nil, body=nil)
      puts "SECRET KEY: #{body[:secret_key]}"
      User.is_admin_key?(body[:secret_key]) if body[:admin] == true
    end
  end

  helpers AuthorizationHelper
end