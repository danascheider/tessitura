module Sinatra
  module Tessitura
    module Routing
      module GeoFilterRoutes
        def self.registered(app) 
          app.post '/geofilter' do 
            if request_body[:state] || request_body[:zip]
              filter = GeoFilter.new(Organization, request_body)
              filter.filter!.to_json
            else
              [422, "Error: Please include state or postal code."]
            end
          end
        end
      end
    end
  end
end