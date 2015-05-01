module Sinatra
  module ErrorHandling

    # The ++parse_json++ method wraps the ++JSON::parse++ method, rescuing parser
    # errors to prevent exceptions. It takes a JSON ++object++ as an argument and
    # returns a corresponding hash with symbolized keys. In the event ++JSON::parse++
    # results in a ++JSON::ParserError++, ++parse_json++ returns ++nil++.

    def parse_json(object)
      begin
        JSON.parse(object, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end
    end

    # The ++update_resource++ method accepts a hash of ++attributes++ and an ++object++ as
    # arguments. It returns status ++404++ unless the ++object++ is included and the
    # ++attributes++ are a valid hash. If these conditions are true, then error-causing
    # attributes including ++:id++, ++:created_at++, ++:updated_at++, and ++:owner_id++ are
    # removed from the hash.
    #
    # Once the object and attributes are validated, any attributes that are already the same
    # as the object's current ones are removed. 
    #
    # Finally, ++update_resource++ attempts to update ++object++ with the ++attributes++ hash.
    # If this operation is unsuccessful and the attributes hash is empty, it returns status
    # ++200++ and the object itself as a JSON string. However, if the object cannot be updated 
    # because the attributes are invalid, ++update_resource++ returns status ++422++.

    def update_resource(attributes, object=nil)
      return 404 unless !!(object && attributes.clean!(:id, :created_at, :updated_at, :owner_id))
      attributes.reject! {|key, value| value === object[key] }
      object.try_rescue(:update, attributes) || attributes.blank? ? [200, object.to_json] : 422
    end

    # The ++verify_uniform_ownership++ method is used to verify that all the given ++models++
    # are owned by a single user. It returns ++true++ if all the models belong to the same
    # user and ++false++ if any of the models belong to a different user or are unassigned.

    def verify_uniform_ownership(models)
      ids = models.map {|model| model.owner_id }
      ids.uniq.length === 1 ? ids[0] : false
    end
  end

  helpers ErrorHandling
end