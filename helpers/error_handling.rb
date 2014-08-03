class Sinatra::Application
  module ErrorHandling
    def begin_and_rescue(error, status, &block)
      begin
        yield
      rescue error
        status
      end
    end

    def create_resource(klass, attributes)
      begin
        klass.create!(attributes)
        201
      rescue ActiveRecord::RecordInvalid, ActiveRecord::UnknownAttributeError
        422
      end
    end

    def get_resource(klass, id, &block)
      begin
        if block_given? then yield klass.find(id); else klass.find(id); end
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def parse_json(object)
      begin
        JSON.parse object
      rescue JSON::ParserError
        nil
      end
    end
  end

  helpers ErrorHandling
end