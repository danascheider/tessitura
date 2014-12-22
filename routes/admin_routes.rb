module Sinatra
  module Canto
    module Routing
      module AdminRoutes
        def self.registered(app)
          app.post '/admin/users' do 
            return 422 unless u = User.try_rescue(:create, request_body)
            [201, u.to_json]
          end

          app.get '/admin/users' do 
            return_json(User.all)
          end
        end
      end
    end
  end
end