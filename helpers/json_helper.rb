class Sinatra::Application
  module JSONHelper
    def request_body
      begin
        JSON.parse request.body.read, symbolize_names: true
      rescue(JSON::ParserError)
        nil
      end
    end
  end

  helpers JSONHelper
end