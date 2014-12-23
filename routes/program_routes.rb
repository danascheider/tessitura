module Sinatra
  module Canto
    module Routing
      module ProgramRoutes
        def self.registered(app)
          app.post '/organizations/:id/programs' do |id|
            (body = request_body)[:organization_id] = id.to_i
            return 422 unless new_program = Program.try_rescue(:create, body)
            [201, new_program.to_json]
          end
        end
      end
    end
  end
end