class Sinatra::Application
  module ErrorHandling
    def begin_and_rescue(error, status, &block)
      begin
        yield
      rescue error
        status
      end
    end

    def get_resource(klass, id, &block)
      begin
        klass.find(id)
        yield klass.find(id) if block_given?
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