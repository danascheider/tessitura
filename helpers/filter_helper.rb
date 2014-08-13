class Sinatra::Application
  module FilterHelper

    def get_filtered(hash)
      @filter = hash['filters']
      @filter['owner_id'] = hash['user']
      Task.where(@filter)
    end

    def filter_resources(hash)
      filter = get_filtered(hash).map {|task| task.to_hash }
      filter.to_json
    end

  end

  helpers FilterHelper
end