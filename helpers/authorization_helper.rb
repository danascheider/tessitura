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
      current_user.id == user_id || admin_access?
    end

    def current_user
      User.find_by(username: @auth.credentials.first)
    end

    def protected!
      return if authorized?
      access_denied
    end

    def setting_admin?
      @request_body && @request_body.has_key?('admin')
    end

    def task_route_boilerplate(id)
      return 404 unless(@task = get_resource(Task, id))
      halt 401 unless authorized_for_resource?(@task.user.id)
    end

    def user_route_boilerplate(id)
      return 404 unless @user = get_resource(User, id)
      halt 401 unless current_user.admin? || (current_user.id == id.to_i && !setting_admin?)
    end

    def valid_credentials?
      begin
        @auth.credentials.last == User.find_by(username: @auth.credentials.first).password
      rescue
        false
      end
    end
  end

  helpers AuthorizationHelper
end