module Sinatra
  module Canto
    module Routing
      def self.delete(model, id)
        return 404 unless resource = model[id]
        resource.try_rescue(:destroy) && 204 || 403
      end
    end
  end
end