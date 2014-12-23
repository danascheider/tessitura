module Sinatra
  module Canto
    module Routing
      module ProgramRoutes
        def self.registered(app)
          Sinatra::Canto::Routing::ProgramRoutes.get_routes(app)

          app.post '/organizations/:id/programs' do |id|
            (body = request_body)[:organization_id] = id.to_i
            return 422 unless new_program = Program.try_rescue(:create, body)
            [201, new_program.to_json]
          end
        end

        def self.get_routes(app)
          app.get '/programs/:id' do |id|
            Program[id] && Program[id].to_json || 404
          end

          app.get '/organizations/:id/programs' do |id|
            Organization[id] && (Organization[id].programs || []).to_json || 404
          end
        end
      end
    end
  end
end