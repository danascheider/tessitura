class Sinatra::Application
  module ParamsHelper
    # FIX: This module currently doesn't accomplish what we need it to.
    ALLOWED_PARAMS = [ 'complete', 'status', 'priority', 'deadline', 'title', 'created', 'updated' ]

    def validate_params(params)
      params.delete_if {|key, value| !ALLOWED_PARAMS.include? key }
    end
  end

  helpers ParamsHelper
end
