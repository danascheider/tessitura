module Sinatra
  module Tessitura
    module Routing
      module OrganizationRoutes

        def self.registered(app)
          OrganizationRoutes.get_paths(app)

          app.post '/organizations' do 
            Routing.post(Organization, request_body)
          end

          app.put '/organizations/:id' do |id|
            update_resource(request_body, Organization[id]) || 404
          end

          app.delete '/organizations/:id' do |id|
            Routing.delete(Organization, id)
          end
        end

        def self.get_paths(app)
          app.get '/organizations/:id' do |id|
            Routing.get_single(Organization, id)
          end

          app.get '/organizations' do 
            (Organization.all || []).to_json
          end
        end
      end
    end
  end
end