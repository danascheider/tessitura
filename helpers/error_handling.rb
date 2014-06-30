class Sinatra::Application
  module ErrorHandling
    def begin_and_rescue(error, status, &block)
      begin
        yield
      rescue error
        status
      end
    end
  end

  helpers ErrorHandling
end