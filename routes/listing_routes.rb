module Sinatra
  module Canto
    module Routing
      module ListingRoutes
        def self.registered(app)
          app.post '/listings' do 
            return 422 unless listing = Listing.try_rescue(:create, request_body)
            [201, listing.to_json]
          end
        end
      end
    end
  end
end