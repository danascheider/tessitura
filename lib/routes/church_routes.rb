module Sinatra
  module Tessitura
    module Routing
      module ChurchRoutes
        def self.registered app 
          app.post '/churches' do 
            Routing.post(Church, request_body)
          end

          app.get '/churches' do 
            Church.all.to_json
          end

          app.get '/churches/:id' do |id|
            Routing.get_single(Church, id)
          end

          app.delete '/churches/:id' do |id|
            Routing.delete(Church, id)
          end
        end
      end
    end
  end
end