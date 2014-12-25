module Sinatra
  module GeneralHelperMethods
    def request_body
      request.body.rewind
      parse_json(request.body.read)
    end
    
    def return_json(obj)
      obj.to_json unless obj.blank?
    end

    def sanitize_attributes(hash)
      hash.clean(:id, :created_at, :updated_at, :owner_id)
    end

    def sanitize_attributes!(hash)
      hash.clean!(:id, :created_at, :updated_at, :owner_id)
    end
  end
end