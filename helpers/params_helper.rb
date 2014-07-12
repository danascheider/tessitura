class Sinatra::Application
  module ParamsHelper
    ALLOWED_PARAMS = [ 'complete', 'status', 'priority', 'deadline', 'title', 'created', 'updated' ]

    def validate_params(params={})
      params.delete_if {|key, value| !ALLOWED_PARAMS.include? key }
    end

    def multiple_values?(value)
      /,/ =~ value ? true : false
    end

    def parse_multiple_values(value)
      value.split(',').map {|val| val.to_sym }
    end
  end

  helpers ParamsHelper
end
