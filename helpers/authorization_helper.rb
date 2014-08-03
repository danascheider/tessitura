class Sinatra::Application
  module AuthorizationHelper
    def current_user
      User.find_by(username: auth.credentials.first)
    end
  end

  helpers AuthorizationHelper
end