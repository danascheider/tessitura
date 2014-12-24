module Sinatra
  module Canto
    module Routing
      module SeasonRoutes
        def self.registered(app)
          app.post '/programs/:id/seasons' do |id|
            (body = request_body)[:program_id] = id.to_i
            Routing.post(Season, body)
          end
        end
      end
    end
  end
end