class Sinatra::Application
  module AuthorizationHelper
    def admin_access?
      current_user.admin?
    end

    def admin_only!
      return if authorized? && admin_access?
      access_denied
    end

    def access_denied
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Authorization Required\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && valid_credentials?
    end

    def authorized_for_resource?(user_id)
      (current_user.id == user_id && !setting_admin?) || admin_access?
    end

    def current_user
      User.find_by(username: @auth.credentials.first)
    end

    def protect(klass)
      return 404 unless klass.exists?(@id) && (@resource = klass.find(@id))
      return if authorized? && authorized_for_resource?(@resource.owner_id)
      access_denied
    end

    def setting_admin?
      @request_body && @request_body.has_key?('admin')
    end

    def valid_credentials?
      begin
        @auth.credentials.last == User.find_by(username: @auth.credentials.first).password
      rescue
        false
      end
    end

    def validate_standard_create
      @request_body.has_key?('admin') ? access_denied : return
    end
  end

  helpers AuthorizationHelper
end