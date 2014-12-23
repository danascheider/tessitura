module Sinatra
  module Canto
    module Routing
      module UserRoutes
        def self.registered(app)

          # Create a new user
          
          app.post '/users' do  
            access_denied if setting_admin?
            Sinatra::Canto::Routing.post(User, request_body)
          end
        end
      end
    end
  end
end