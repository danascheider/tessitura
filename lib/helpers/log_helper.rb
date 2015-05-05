require 'yaml'

module Sinatra

  # The ++LogHelper++ module provides helper methods to be used when generating server
  # logs. These methods generate and format the log entries when called in the route
  # filters.

  module LogHelper

    # The ++CONFIG_INFO++ hash provides information about the location of the app file and 
    # log files.

    CONFIG_INFO = (File.open(File.expand_path('../../../config/config.yml', __FILE__), 'r+') {|f| YAML.load(f)}).symbolize_keys!

    # The ++log_request++ method opens the request log file, identified by the ++:request_log++
    # key in the ++CONFIG_INFO++ hash. It opens the file and appends the formatted
    # ++request_log_entry++ (see below).

    def log_request
      filename = File.expand_path(CONFIG_INFO[:request_log], __FILE__)
      File.open(filename, 'a+') {|file| file.puts request_log_entry }
    end

    # The ++log_response++ method opens the response log file, identified by the 
    # ++:response_log++ key in the ++CONFIG_INFO++ hash. It opens the file and appends 
    # the formatted ++response_log_entry++ (see below).

    def log_response
      filename = File.expand_path(CONFIG_INFO[:response_log], __FILE__)
      File.open(filename, 'a+') {|file| file.puts response_log_entry }
    end

    # The ++request_log_entry++ method lists each key in the ++request.env++ hash
    # on a single line in all caps, adding the request body at the end. It rewinds
    # the request body before returning the formatted log entry.

    def request_log_entry
      entry = []
      request.env.each {|k, v| entry << "#{k.upcase}: #{v}" }
      request.body.rewind
      entry << "BODY: #{parse_json(request.body.read)}"
      "\n" + entry.join("\n")
    end

    # The ++response_log_entry++ method lists the time of the response, the path and
    # method of the request, and the response that was sent. It returns the formatted
    # log entry.

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
