module Sinatra
  module Canto
    module Routing
      module ListingRoutes
        def self.registered(app)
          app.post '/listings' do 
            Sinatra::Canto::Routing.post(Listing, request_body)
          end
        end
      end
    end
  end
end