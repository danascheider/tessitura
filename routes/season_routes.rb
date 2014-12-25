module Sinatra
  module Canto
    module Routing
      module SeasonRoutes
        def self.registered(app)
          app.post '/programs/:id/seasons' do |id|
            (body = request_body)[:program_id] = id.to_i
            Routing.post(Season, body)
          end

          app.put '/seasons/:id' do |id|
            return 404 unless Season[id]
            update_resource(request_body, Season[id]) || 422
          end

          app.delete '/seasons/:id' do |id|
            Routing.delete(Season, id)
          end

          SeasonRoutes.get_routes(app)
        end

        def self.get_routes(app)
          app.get '/seasons/:id' do |id|
            Routing.get_single(Season, id)
          end

          app.get '/programs/:id/seasons' do |id|
            return 404 unless Program[id]
            (Season.where(program_id: id).exclude(stale: true) || []).to_json
          end

          app.get '/programs/:id/seasons/all' do |id|
            return 404 unless Program[id]
            (Program[id].seasons || []).to_json
          end
        end
      end
    end
  end
end