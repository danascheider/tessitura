module Sinatra
  module Tessitura
    module Routing
      module ChurchRoutes
        def self.registered app 
          app.post '/churches' do 
            Routing.post(Church, request_body)
          end
        end
      end
    end
  end
end