module Sinatra
  module Canto
    module Routing
      module UserRoutes
        def self.registered(app)

          # Create a new user
          
          app.post '/users' do  
            access_denied if setting_admin?
            return 422 unless new_user = User.try_rescue(:create, request_body)
            [201, new_user.to_json]
          end
        end
      end
    end
  end
end