module TessituraConfig
  FILES = {
    app_file: File.expand_path('../../lib/tessitura.rb', __FILE__),
    db_loggers: [File.expand_path('../../log/db.log', __FILE__)],
    request_log: File.expand_path('../../log/requests.log', __FILE__),
    response_log: File.expand_path('../../log/responses.log', __FILE__),
    credential_store_file: File.expand_path('../../oauth2/calendar.rb-oauth2.json', __FILE__)
  }

  def self.config_info
    self::FILES
  end
end