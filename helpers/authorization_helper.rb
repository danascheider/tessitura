# CREATE requests
# - Always authorized unless request includes 'admin':true
# - Always

class Sinatra::Application
  module AuthorizationHelper
    def create_authorized?(body)
      admin_approved?(body[:secret_key]) || !body[:admin]
    end

    def read_authorized?(id, body)
      admin_approved?(body[:secret_key]) || user_match?(id, body[:secret_key])
    end

    def update_authorized?(id, body)
      admin_approved?(body[:secret_key]) || (user_match?(id, body[:secret_key]) && !body[:admin])
    end

    def delete_authorized?(id, body)
      admin_approved?(body[:secret_key]) || user_match?(id, body[:secret_key])
    end

    def admin_approved?(key)
      User.find_by(secret_key: key) && User.find_by(secret_key: key).admin?
    end

    def user_match?(id, key)
      User.find_by(secret_key: key).id == id
    end
  end

  helpers AuthorizationHelper
end