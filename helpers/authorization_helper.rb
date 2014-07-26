class Sinatra::Application
  module AuthorizationHelper
    def authorized_user?(id, body)
      key = body[:secret_key]
      return nil unless valid_key?(key)
      User.is_admin_key?(key) || (User.find_by(secret_key: key).id == id && !body[:admin])
    end

    def validate_and_create_user(body)
      (valid_admin_creation?(body) || !body.has_key?(:admin)) ? User.create!(body) : nil
    end

    def validate_and_update_user(id, body)
      authorized_user?(id, body) ? User.find(id).update!(body) : nil
    end

    def valid_admin_creation?(body)
      body.has_key?(:admin) && body.has_key?(:secret_key) && User.is_admin_key?(body[:secret_key])
    end

    def valid_key?(key)
      !!User.find_by(secret_key: key)
    end
  end

  helpers AuthorizationHelper
end