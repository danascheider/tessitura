module Sinatra
  module Canto
    module Routing
      def self.delete(model, id)
        return 404 unless resource = model[id]
        resource.try_rescue(:destroy) && 204 || 403
      end

      def self.post(model, body)
        return 422 unless new_resource = model.try_rescue(:create, body)
        [201, new_resource.to_json]
      end
    end
  end
end