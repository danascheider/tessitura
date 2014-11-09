module Sinatra
  module LogHelper
    def log_request
      filename = File.expand_path('log/canto.log')
      File.open(filename, 'a+') {|file| file.puts request_log_entry }
    end

    def log_response
      filename = File.expand_path('log/response.log')
      File.open(filename, 'a+') {|file| file.puts response_log_entry }
    end

    def request_log_entry
      entry = []
      request.env.each {|k, v| entry << "#{k.upcase}: #{v}" }
      request.body.rewind
      entry << "BODY: #{parse_json(request.body.read)}"
      "\n" + entry.join("\n")
    end

    def response_log_entry
      [
        "\n==============================================================",
        "\n#{Time.now}: #{request.env['REQUEST_METHOD']} - #{request.env['PATH_INFO']}",
        "\n==============================================================",
        "\n#{response.inspect}"
      ].join('')
    end
  end
end