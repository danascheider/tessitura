module Sinatra
  module GeneralHelperMethods
    def return_json(obj)
      nil_values = [ 'null', '', {}, nil, [] ]
      obj.to_json unless nil_values.include? obj
    end
  end

  helpers GeneralHelperMethods
end