class Sinatra::Application
  module AuthorizationHelper
    def authorized?(method, resource, id=nil, body=nil)
      return true if User.is_admin_key?(body[:secret_key])
    end
  end

  helpers AuthorizationHelper
end