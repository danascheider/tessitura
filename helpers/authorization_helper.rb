class Sinatra::Application 
  module AuthorizationHelper
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not Authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided && @auth.basic? && @auth.credentials && authorized_credentials?(@auth.credentials)
    end

    def authorized_credentials?(credentials, id=nil)
      begin
        user = User.find_by(username: credentials[0])
      rescue(ActiveRecord::RecordNotFound)
        return false
      end

      (credentials[1] == user.password && id == user.id) || user.admin? ? true : false
    end
  end

  helpers AuthorizationHelper
end