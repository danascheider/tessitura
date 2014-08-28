module Sinatra
  module ErrorHandling
    def create_resource(klass, attributes)
      begin
        klass.create!(attributes)
        201
      rescue ActiveRecord::RecordInvalid, ActiveRecord::UnknownAttributeError
        422
      end
    end

    def destroy_resource(object=nil)
      begin
        object.try(:destroy!) ? 204 : 404
      rescue ActiveRecord::RecordNotDestroyed
        403
      end
    end

    def get_resource(klass, id, &block)
      return nil unless klass.exists?(id)
      if block_given? then yield klass.find(id); else klass.find(id); end
    end

    def parse_json(object)
      begin
        JSON.parse(object, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end
    end


    def update_resource(attributes, object=nil)
      begin
        object.try(:update!, attributes) ? 200 : 404
      rescue ActiveRecord::RecordInvalid, ActiveRecord::UnknownAttributeError
        422
      end
    end
  end

  helpers ErrorHandling
end