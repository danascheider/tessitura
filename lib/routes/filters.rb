module Sinatra
  module Tessitura
    module Routing
      module Filters
        def self.registered(app)
          Sinatra::Tessitura::Routing::Filters.logging_filters(app)
          Sinatra::Tessitura::Routing::Filters.admin_auth_filter(app)
          Sinatra::Tessitura::Routing::Filters.proprietary_auth_filters(app)
          Sinatra::Tessitura::Routing::Filters.communal_auth_filter(app)
        end

        def self.logging_filters(app)
          app.before do 
            @id = request.path_info.match(/\d+/).to_s
            log_request
          end

          app.after do 
            log_response
          end
        end

        def self.admin_auth_filter(app)
          app.before /\/admin\/*/ do 
            admin_only!
          end
        end

        def self.communal_auth_filter(app)
          app.before /\/(organizations|programs|seasons)\/*/ do 
            request.get? ? protect_communal : admin_only!
          end
        end

        def self.proprietary_auth_filters(app)
          app.before /^\/users\/(\d+)\/tasks(\/)?/ do 
            request.put? ? protect_collection(request_body) : protect(User)
          end

          app.before /^\/(users|tasks)\/(\d+)(\/*)?/ do 
            request.path.match(/users/) ? protect(User) : protect(Task)
          end
        end
      end
    end
  end
end