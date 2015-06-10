require 'google/api_client'

module Sinatra
  module Tessitura
    module Routing
      module GoogleAPIRoutes
        def self.registered(app)
          GoogleAPIRoutes.get_routes(app)
        end

        def self.get_routes(app)
          app.get '/users/:id/calendar' do |id|
          end
        end
      end
    end
  end
end