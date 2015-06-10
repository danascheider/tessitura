module Sinatra
  module Tessitura
    module Routing
      module Oauth2Routes
        def self.registered(app)
          Oauth2Routes.get_routes(app)
        end

        def self.get_routes(app)
          app.get '/oauth2authorize' do 
            # Request authorization
            redirect oauth2_credentials.authorization_uri.to_s, 303
          end

          app.get '/oauth2callback' do 
            # Exchange token
            oauth2_credentials.code = params[:code] if params[:code]
            oauth2_credentials.fetch_access_token!
            redirect '/'
          end
        end
      end
    end
  end
end