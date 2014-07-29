
class Sinatra::Application
  module AuthorizationHelper
    def create_authorized?(body=nil)
      return false unless body
      admin_approved?(body[:secret_key]) || !body[:admin]
    end

    def read_authorized?(id, body=nil)
      begin
        admin_approved?(body[:secret_key]) || user_match?(id, body[:secret_key])
      rescue(NoMethodError)
        false
      end
    end

    def update_authorized?(id, body=nil)
      begin
        admin_approved?(body[:secret_key]) || (user_match?(id, body[:secret_key]) && !body[:admin])
      rescue(NoMethodError)
        false
      end
    end

    def delete_authorized?(id, body=nil)
      begin
        admin_approved?(body[:secret_key]) || user_match?(id, body[:secret_key])
      rescue(NoMethodError)
        false
      end
    end

    def admin_approved?(key)
      User.find_by(secret_key: key) && User.find_by(secret_key: key).admin? ? true : false
    end

    def user_match?(id, key)
      User.find_by(secret_key: key).id == id
    end
  end

  helpers AuthorizationHelper
end