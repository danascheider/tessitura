module Sinatra
  module AuthorizationHelper

    # The ++admin_only!++ method checks to make sure the logged-in user (i.e., the
    # one whose token is in the ++Authorization++ header) is authorized as an admin.
    # The identity of the logged-in user is determined based on the username
    # included in the token provided in the header. If the request does not include 
    # an ++Authorization++ header, the token is invalid, or the user whose credentials 
    # are used is not an admin, ++admin_only!++ calls ++access_denied++, halting the
    # request and returning a ++401++ status code.

    def admin_only!
      return if authorized? && current_user.admin?
      access_denied
    end

    # The ++access_denied++ method halts the current request and returns a ++401++
    # status code, adding the ++WWW-Authenticate++ header to the response and a
    # text response body reading "Authorization Required\n".

    def access_denied
      headers('WWW-Authenticate' => 'Basic realm="Restricted Area"')
      halt 401, "Authorization Required\n"
    end

    # The ++authorized?++ method creates a new ++Rack::Auth::Basic::Request++ object
    # from the ++request.env++ hash. The ++#provided?++ and ++#basic?++ methods
    # called ensure the authorization header was required and that it is consistent
    # with the HTTP Basic authentication scheme. ++authorized?++ also verifies that
    # the header has included the correct password for the given username.

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)      
      @auth.provided? && @auth.basic? && valid_credentials?
    end

    # The ++authorized_for_resource++ method verifies that the logged-in user (i.e.,
    # the user whose credentials are included in the ++Authorization++ header) is 
    # allowed to access the resource being requested. It determines this as follows:
    # 
    #   I.  If the user is an admin, they are allowed access to all resources
    #   II. If the user is not an admin:
    #       1. Their ++id++ attribute has to match the given ++user_id++, ensuring
    #          they only have access to resources belonging or assigned to them
    #       2. They may not set the ++admin++ attribute on their own account.
    #
    # All requests by non-admins attempting to set the ++admin++ attribute on any
    # account will not be processed and a ++401++ status code will be returned with
    # a ++WWW-Authenticate++ header.
    #
    # FIX: Non-admins attempting to set the ++admin++ attribute should be blocked,
    #      because there is no way for them to update that attribute through the 
    #      GUI, so they are known to be tech-savvy and have gone to some trouble
    #      to do that.

    def authorized_for_resource?(user_id)
      (current_user.id == user_id && !setting_admin?) || current_user.admin?
    end

    # The ++current_user++ method checks the ++@auth++ object's ++credentials++
    # and returns the user whose username is included in the credentials. If no
    # credentials are given, the request will not have gotten this far, because
    # it will have been already stopped before this even gets called.

    def current_user
      User.find(username: @auth.credentials.first)
    end

    # The ++login++ method is called when the client submits a request to the 
    # ++/login++ route. Since the API is stateless, it does not store session 
    # information, but simply checks if the requesting user is authorized and, 
    # if so, returns that user's profile information in JSON format. If the 
    # user is found to be unauthorized, ++login++ calls ++access_denied++ to 
    # halt the request with status +401+.

    def login
      return current_user.to_json if authorized?
      access_denied
    end

    # The ++protect++ method takes as an argument the ++klass++ of the resource being
    # requested (i.e., ++User++, ++Task++, ++Program++, etc.). It then verifies that the
    # requested resource exists, using the reslource ++@id++ set in the before filter
    # (which is taken from the request's ++path_info++). If the resource does not exist,
    # it returns a ++404++ status code. Otherwise, it verifies that the requesting user
    # is authorized to access the resource requested and, if not, calls ++access_denied++.
    # The ++protect++ method returns ++nil++ if authentication is successful.

    def protect(klass)
      return 404 unless @resource = klass[@id]
      access_denied unless authorized? && authorized_for_resource?(@resource.owner_id)
    end

    # The ++protect_collection++ method is used for the mass update of tasks. The 
    # mass update route, ++/users/:id/tasks/all++, receives requests with an entire
    # collection of tasks, which all need to be updated. ++protect_collection++ 
    # takes as an argument the request ++body++, and makes its judgment as follows:
    #   1. If the request has been sent with an :id parameter not corresponding to 
    #      a registered user, the method returns status ++404++.
    #   2. If the requesting user is not an admin, they must be the owner of every
    #      task in the collection. If they are not, ++protect_collection++ calls
    #      ++access_denied++.
    #   3. If the requesting user is an admin, they get access to anything they want.

    def protect_collection(body)
      allowed = body.select {|hash| Task[hash[:id]].try_rescue(:owner_id) === @id.to_i}
      access_denied unless User[@id] && authorized? && (body === allowed || current_user.admin?)
    end

    # The ++protect_communal++ method controls access to resources accessible by any
    # registered user, such as programs and listings. It returns ++nil++ if the user
    # has included a valid ++Authorization++ header; if not, it calls ++access_denied++.

    def protect_communal
      access_denied unless authorized?
    end

    # The ++setting_admin?++ method checks whether the ++request_body++ object includes
    # the key ++:admin++ anywhere. If the key ++admin++ occurs in the request body,
    # it returns ++true++; if not, it returns ++false++.
    #
    # FIX: This should do a deep search for an ++:admin++ key, so a nested object can't
    #      contain such a key either.

    def setting_admin?
      request_body.try(:respond_to?, :has_key?) && (request_body.try(:has_key?, :admin) || request_body.try(:has_key?, 'admin'))
    end

    # The ++valid_credentials?++ method verifies that the password provided to the 
    # ++@auth++ object are the proper credentials for an actual user. It returns 
    # ++false++ if:
    # 
    #   * No credentials are provided
    #   * No user with the given username exists
    #   * The password does not match that of the user whose username is included
    #
    # Otherwise, ++valid_credentials?++ returns true.

    def valid_credentials?
      begin
        @auth.credentials.last == User.find(username: @auth.credentials.first).password
      rescue NoMethodError
        false
      end
    end
  end
end