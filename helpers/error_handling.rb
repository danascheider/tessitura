module Sinatra
  module ErrorHandling
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

    def set_attributes(attributes, object=nil)
      return nil unless object && attributes
      bad_keys = [:id, :created_at, :updated_at, :owner_id]
      object.set(attributes.reject {|k,v| k.in?(bad_keys)})
    end

    # FIX: In Task spec, this method appears to have bypassed Sequel validation
    #      and updated the task despite validation failure. However, this is not
    #      corroborated in IRB, where it works as expected.
    def update_resource(attributes, object=nil)
      return 404 unless object && attributes

      bad_keys = [:id, :created_at, :updated_at]

      attributes.reject! {|key, value| key.in?(bad_keys) || (value === object[key]) }
      return [200, object.to_json] if attributes.blank?

      object.try_rescue(:update, attributes) ? [200, object.to_json] : 422
    end
  end

  helpers ErrorHandling
end