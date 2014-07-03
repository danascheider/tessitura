class Sinatra::Application
  module JSONHelper
    def request_body
      JSON.parse request.body.read, symbolize_names: true
    end
  end

  helpers JSONHelper
end