module Sinatra
  module ErrorHandling
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

    def update_all(array, klass)
      update_all = Proc.new do 
        array.each do |hash|
          bad_keys = [:id, :created_at, :updated_at, :owner_id]
          klass[hash[:id]].update(hash.reject! {|k,v| k.in?(bad_keys) })
        end
      end
    end

    def update_resource(attributes, object=nil)
      return 404 unless !!(object && sanitize_attributes!(attributes))

      attributes.reject! {|key, value| value === object[key] }
      object.try_rescue(:update, attributes) || attributes.blank? ? [200, object.to_json] : 422
    end
  end

  helpers ErrorHandling
end