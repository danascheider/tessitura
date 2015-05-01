module Sinatra
  module Canto
    module Routing
      module UserRoutes
        def self.registered(app)

          # Create a new user
          app.post '/users' do  
            access_denied if setting_admin?
            Routing.post(User, request_body)
          end

          app.get '/users/:id' do |id|
            Routing.get_single(User, id)
          end

          # `@resource` is defined in the authorization filters

          app.put '/users/:id' do |id|
            update_resource(request_body, @resource)
          end

          app.delete '/users/:id' do |id|
            Routing.delete(User, id)
          end
        end
      end
    end
  end
end