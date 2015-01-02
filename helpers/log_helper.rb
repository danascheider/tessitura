require 'yaml'

module Sinatra
  module LogHelper
    CONFIG_INFO = (File.open(File.expand_path('config/config.yml'), 'r+') {|f| YAML.load(f)}).symbolize_keys!

    def log_request
      filename = CONFIG_INFO[:request_log]
      File.open(filename, 'a+') {|file| file.puts request_log_entry }
    end

    def log_response
      filename = CONFIG_INFO[:response_log]
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