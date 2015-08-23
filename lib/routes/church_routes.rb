module Sinatra
  module Tessitura
    module Routing
      module ChurchRoutes
        def self.registered app 
          app.post '/churches' do 
            Routing.post(Church, request_body)
          end

          app.delete '/churches/:id' do |id|
            Routing.delete(Church, id)
          end
        end
      end
    end
  end
end