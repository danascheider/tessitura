module Sinatra
  module AuthorizationHelper
    def admin_only!
      return if authorized? && current_user.admin?
      access_denied
    end

    def access_denied
      headers('WWW-Authenticate' => 'Basic realm="Restricted Area"')
      halt 401, "Authorization Required\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && valid_credentials?
    end

    def authorized_for_resource?(user_id)
      (current_user.id == user_id && !setting_admin?) || current_user.admin?
    end

    def current_user
      User.find(username: @auth.credentials.first)
    end

    def login
      return {user: current_user}.to_json if authorized?
      access_denied
    end

    def protect(klass)
      return 404 unless (@resource = klass[@id])
      access_denied unless authorized? && authorized_for_resource?(@resource.owner_id)
    end

    def protect_collection(body)
      return 404 unless (owner = User[@id])
      allowed = body.select {|hash| Task[hash[:id]].owner_id == @id}
      access_denied unless authorized? && (body === allowed || current_user.admin?)
    end

    def setting_admin?
      request_body.try(:has_key?, :admin) || request_body.try(:has_key?, 'admin')
    end

    def valid_credentials?
      begin
        @auth.credentials.last == User.find(username: @auth.credentials.first).password
      rescue NoMethodError
        false
      end
    end
  end
end