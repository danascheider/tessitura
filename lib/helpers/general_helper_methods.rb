module Sinatra
  module GeneralHelperMethods

    # The ++request_body++ method rewinds the message body of the request,
    # parses the JSON, and returns the parsed body as a hash with symbolized
    # keys.

    def request_body
      request.body.rewind
      parse_json(request.body.read)
    end

    # The ++return_json++ method takes as an argument an ++object++, which it
    # returns as JSON unless the object is blank, empty, or falsey. In that 
    # case, it returns ++nil++.
    
    def return_json(object)
      object.to_json unless object.blank?
    end

    # The ++santize_attributes++ method takes a ++hash++ as an argument and returns
    # a copy of the hash with the keys ++:id++, ++:created_at++, ++:updated_at++, and
    # ++:owner_id++, if present, removed. These are attributes that are not allowed to
    # be set on Tessitura models and will raise exceptions if they are passed to a Sequel
    # model. For this reason, ++sanitize_attributes++ is used to prevent such predictable
    # errors from coming up.

    def sanitize_attributes(hash)
      hash.clean(:id, :created_at, :updated_at, :owner_id)
    end

    # The ++santize_attributes!++ method takes a ++hash++ as an argument and modifies the 
    # hash in place, deleting the  ++:id++, ++:created_at++, ++:updated_at++, and ++:owner_id++ 
    # keys. These are attributes that are not allowed to be set on Tessitura models and will raise 
    # exceptions if they are passed to a Sequel model.

    def sanitize_attributes!(hash)
      hash.clean!(:id, :created_at, :updated_at, :owner_id)
    end
  end
end