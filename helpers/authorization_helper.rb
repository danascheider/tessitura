class Sinatra::Application
  module AuthorizationHelper
    def user_route_boilerplate(id)
      return 404 unless (@user = get_resource(User, id))
      halt 401 unless current_user.admin? || current_user.id == id.to_i && !setting_admin?
    end

    def task_route_boilerplate(id)
      return 404 unless (@task = get_resource(Task, id))
      halt 401 unless current_user.id == @task.user.id || current_user.admin?
    end

    def setting_admin?
      @request_body && @request_body.has_key?('admin')
    end

    def current_user
      User.find_by(username: auth.credentials.first)
    end
  end

  helpers AuthorizationHelper
end