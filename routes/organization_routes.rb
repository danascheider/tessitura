module Sinatra
  module Canto
    module Routing
      module OrganizationRoutes

        def self.registered(app)
          app.get '/organizations/:id' do |id|
            Organization[id].to_json || 404
          end

          app.get '/organizations' do 
            return_json(Organization.all) || [].to_json 
          end

          app.post '/organizations' do 
            admin_only!
            return 422 unless new_org = Organization.try_rescue(:create, request_body)
            [201, new_org.to_json]
          end

          app.put '/organizations/:id' do |id|
            admin_only!
            update_resource(request_body, Organization[id])
          end
        end

      end
    end
  end
end