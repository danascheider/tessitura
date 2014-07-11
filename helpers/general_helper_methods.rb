class Sinatra::Application
  module GeneralHelperMethods
    def to_bool(string)
      string == 'false' || string == 'nil' ? false : true
    end

    def interpret_complete_param(string)
      to_bool(string) == true ? Task.complete.to_json : Task.incomplete.to_json 
    end
  end

  helpers GeneralHelperMethods
end