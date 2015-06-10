class Tessitura < Sinatra::Base

  # The ++OAUTH2_CONFIG++ object parses the file designated in the ++TessituraConfig::FILES++
  # hash and stores the data from its 'web' key, where the client credentials for the
  # Google API are stored.

  OAUTH2_CONFIG = JSON.parse(File.read(TessituraConfig::FILES[:credential_store_file]))['web']

  # When ++OAuth2Helper++ is registered to the app, it configures the app as follows:
  #   * Sessions are enabled as required by OAuth2
  #   * A ++Google::APIClient++ object is initialized for the application
  #   * The ++client_id++, ++client_secrets++, and ++scope++ for the ++Google::APIClient++ 
  #     object are set based on values from the ++OAUTH2_CONFIG++ object
  #   * The ++Google::APIClient++ object is assigned to the app's ++api_client++ setting
  #   * The app's ++calendar++ setting is set to the return value of the ++discovered_api++
  #     method called on the client

  configure do 
    enable :sessions

    client                              = Google::APIClient.new(application_name: 'Tessitura', application_version: TessituraPackage::Version::STRING)
    client.authorization.client_id      = OAUTH2_CONFIG['client_id']
    client.authorization.client_secret  = OAUTH2_CONFIG['client_secret']
    client.authorization.scope          = 'https://www.googleapis.com/auth/calendar'

    set :api_client, client
    set :calendar, client.discovered_api('calendar', 'v3')
  end
end

module Sinatra
  module OAuth2Helper
    # The ++api_client++ method returns the ++Google::APIClient++ object from the app's
    # settings, which is created when the helper is registered.

    def api_client; settings.api_client; end

    # The ++calendar++ method returns the Google Calendar API object from the app's
    # settings, which is created when the helper is registered.

    def calendar_api; settings.calendar; end

    # The ++oauth2_credentials++ method sets the ++@authorization++ variable to
    # include the ++redirect_uri++ and session token from the ++api_client++ setting
    # on the app.

    def oauth2_credentials
      @authorization ||= (
        auth = api_client.authorization.dup
        auth.redirect_uri = 'https://api.tessitura.io/oauth2callback'
        auth.update_token!(session)
        auth
      )
    end
  end
end