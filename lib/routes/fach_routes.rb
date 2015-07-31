module Sinatra
  module Tessitura
    module Routing
      module FachRoutes
        def self.registered(app)
          app.get '/fachs' do 
            [200, Fach.all.to_json]
          end

          app.get '/fachs/:id' do |id|
            Fach[id] ? [200, Fach[id].to_json] : 404
          end
        end
      end
    end
  end
end