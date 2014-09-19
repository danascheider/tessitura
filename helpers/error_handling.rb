class Object
  # This super useful method comes from ActiveSupport. Since I'm trying
  # to get Rails fully out of this project, I am re-implementing any 
  # ActiveSupport methods I need... it's just not even worth it.
  def try(method, *args)
    begin
      self.send(method, *args)
    rescue NoMethodError, Sequel::ValidationFailed, Sequel::HookFailed, Sequel::Error
      nil
    end
  end
end

module Sinatra
  module ErrorHandling
    def create_resource(klass, attributes)
      klass.try(:create, attributes) ? 201 : 422
    end

    def destroy_resource(object)
      return 404 unless object
      object.try(:destroy) ? 204 : 403
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


    def update_resource(attributes, object=nil)
      return 404 unless object
      object.try(:update, attributes) ? 200 : 422
    end
  end

  helpers ErrorHandling
end

# Failures 3, 6, and 7 will be most fruitful to pursue right now