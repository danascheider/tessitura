class Sinatra::Application
  module GeneralHelperMethods
    def to_bool(string)
      string == 'false' || string == 'nil' ? false : true
    end
  end

  helpers GeneralHelperMethods
end