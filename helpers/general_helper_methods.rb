class Sinatra::Application
  module GeneralHelperMethods
    def find_task(id)
      Task.find(id)
    end

    def find_by(attribute, value)
      Task.find_by(attribute, value)
    end
  end

  helpers GeneralHelperMethods
end