module Sinatra
  module Canto
    module Routing
      module ProgramRoutes
        def self.registered(app)
          ProgramRoutes.get_routes(app)

          app.delete '/programs/:id' do |id|
            Routing.delete(Program, id)
          end

          app.post '/organizations/:id/programs' do |id|
            (body = request_body)[:organization_id] = id.to_i
            Routing.post(Program, body)
          end

          app.put '/programs/:id' do |id|
            update_resource(request_body, Program[id])
          end
        end

        def self.get_routes(app)
          app.get '/programs/:id' do |id|
            Routing.get_single(Program, id)
          end

          app.get '/organizations/:id/programs' do |id|
            Organization[id] && (Organization[id].programs || []).to_json || 404
          end

          app.get '/programs' do
            (Program.all || []).to_json
          end
        end
      end
    end
  end
end