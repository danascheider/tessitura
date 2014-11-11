module Sinatra
  module GeneralHelperMethods
    def request_body
      request.body.rewind
      parse_json(request.body.read)
    end
    
    def return_json(obj)
      obj.to_json unless obj.blank?
    end
  end
end