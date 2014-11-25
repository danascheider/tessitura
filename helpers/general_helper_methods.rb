module Sinatra
  module GeneralHelperMethods
    def request_body
      request.body.rewind
      parse_json(request.body.read)
    end
    
    def return_json(obj)
      obj.to_json unless obj.blank?
    end

    def sanitize_attributes!(hash)
      bad_keys = [:id, :created_at, :updated_at, :owner_id]
      hash.reject! {|k,v| k.in?(bad_keys) }
      hash
    end
  end
end