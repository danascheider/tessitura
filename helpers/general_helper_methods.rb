class Sinatra::Application
  module GeneralHelperMethods
    def to_bool(string)
      string == 'false' || string == 'nil' ? false : true
    end

    def return_json(obj)
      nil_values = [ 'null', '', {}, nil, [] ]
      obj.to_json unless nil_values.include? obj
    end
  end

  helpers GeneralHelperMethods
end