module Sinatra
  module ErrorHandling
    def parse_json(object)
      begin
        JSON.parse(object, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end
    end

    def update_resource(attributes, object=nil)
      return 404 unless !!(object && attributes.clean!(:id, :created_at, :updated_at, :owner_id))

      attributes.reject! {|key, value| value === object[key] }
      object.try_rescue(:update, attributes) || attributes.blank? ? [200, object.to_json] : 422
    end

    def verify_uniform_ownership(models)
      ids = models.map {|model| model.owner_id }
      ids.uniq.length === 1 ? ids[0] : false
    end
  end

  helpers ErrorHandling
end