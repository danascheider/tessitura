module Sinatra
  module Canto
    module Routing
      module AdminRoutes
        def self.registered(app)
          app.post '/admin/users' do 
            Sinatra::Canto::Routing.post(User, request_body)
          end

          app.get '/admin/users' do 
            return_json(User.all)
          end
        end
      end
    end
  end
end