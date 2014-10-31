module Sinatra
  module GeneralHelperMethods
    def return_json(obj)
      obj.to_json unless obj.blank?
    end

    def decode_form_data(data) 
      form_data = URI::decode_www_form(data).flatten
      hash = Hash[*form_data]
      hash
    end
  end
end