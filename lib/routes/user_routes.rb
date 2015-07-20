module Sinatra
  module Tessitura
    module Routing
      module UserRoutes
        def self.registered(app)

          # Create a new user
          app.post '/users' do  
            access_denied if setting_admin?

            if (body = request_body).has_key? :fach
              body[:fach_id] = Fach.infer(body[:fach]).id
              body.delete :fach
            end

            Routing.post(User, body)
          end

          app.get '/users/:id' do |id|
            Routing.get_single(User, id)
          end

          # `@resource` is defined in the authorization filters

          app.put '/users/:id' do |id|

            if (body = request_body).has_key? :fach
              body[:fach_id] = Fach.infer(body[:fach]).id
              body.delete :fach
            end

            update_resource(body, @resource)
          end

          app.delete '/users/:id' do |id|
            Routing.delete(User, id)
          end
        end
      end
    end
  end
end