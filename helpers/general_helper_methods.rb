class Sinatra::Application
  module GeneralHelperMethods
    def find_task(id)
      Task.find(id)
    end

    def find_by(attribute, value)
      Task.find_by(attribute, value)
    end

    def to_bool(string)
      string == 'false' || string == 'nil' ? false : true
    end

    def interpret_complete_param(string)
      to_bool(string) == true ? Task.complete.to_json : Task.incomplete.to_json 
    end
  end

  helpers GeneralHelperMethods
end