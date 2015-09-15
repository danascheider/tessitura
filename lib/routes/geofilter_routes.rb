module Sinatra
  module Tessitura
    module Routing
      module GeoFilterRoutes
        def self.registered(app) 
          app.post '/geofilter' do 
            filter = GeoFilter.new(Organization, request_body)
            filter.filter!.to_json
          end
        end
      end
    end
  end
end