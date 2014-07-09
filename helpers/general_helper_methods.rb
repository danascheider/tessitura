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
  end

  helpers GeneralHelperMethods
end