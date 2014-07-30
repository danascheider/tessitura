class Sinatra::Application 
  module AuthorizationHelper
    def protected!
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not Authorized\n"
    end

    def is_admin?(username)
      User.find_by(username: username).admin?
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
    end
  end

  helpers AuthorizationHelper
end