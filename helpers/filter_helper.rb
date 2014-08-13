class Sinatra::Application
  module FilterHelper

    def filter_resources(hash)
      @filter = hash['filters']
      @filter['owner_id'] = hash['user']
      @resources = Task.where(@filter)
    end

  end

  helpers FilterHelper
end