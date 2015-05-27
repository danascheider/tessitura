module Sinatra
  module Tessitura
    module Routing
      module ListingRoutes
        def self.registered(app)
          app.post '/listings' do 
            Sinatra::Tessitura::Routing.post(Listing, request_body)
          end
        end
      end
    end
  end
end