module Sinatra
  module ErrorHandling

    def create_resource(klass, attributes)
      klass.try_rescue(:create, attributes) ? 201 : 422
    end

    def destroy_resource(object)
      return 404 unless object
      object.try_rescue(:destroy) ? 204 : 403
    end

    def get_resource(klass, id, &block)
      return nil unless klass[id]
      if block_given? then yield klass[id]; else klass[id]; end
    end

    def parse_json(object)
      begin
        JSON.parse(object, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end
    end

    # FIX: In Task spec, this method appears to have bypassed Sequel validation
    #      and updated the task despite validation failure. However, this is not
    #      corroborated in IRB, where it works as expected.
    def update_resource(attributes, object=nil)
      return 404 unless object && attributes
      attributes.try_rescue(:delete, :id)
      object.try_rescue(:update, attributes) ? 200 : 422
    end
  end

  helpers ErrorHandling
end