module Sinatra
  module GeneralHelperMethods
    def return_json(obj)
      obj.to_json unless obj.blank?
    end
  end

  helpers GeneralHelperMethods
end