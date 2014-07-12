class Sinatra::Application
  module ParamsHelper
    ALLOWED_PARAMS = [ 'complete', 'status', 'priority', 'deadline', 'title', 'created', 'updated' ]

    def validate_params(params)
      params.delete_if {|key, value| !ALLOWED_PARAMS.include? key }
    end
  end

  helpers ParamsHelper
end
