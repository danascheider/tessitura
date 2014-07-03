class Sinatra::Application
  module JSONHelper
    def request_body
      JSON.parse request.body.read
    end
  end

  helpers JSONHelper
end