class Sinatra::Application
  module FilterUtils

    def filter_resources(hash)
      tasks = TaskFilter.new(hash[:filters], hash[:user]).filter.to_a.map {|task| task.to_hash } 
      tasks.to_json
    end

    def time_filter(hash)
      if hash.has_key?(:on)
        hash[key] = Time.utc(value[:on][:year],value[:on][:month],value[:on][:day])
      elsif value.has_key?(:before)
        ["#{key.to_s} < ?", Time.utc(value[:before][:year],value[:before][:month],value[:before][:day])]
      else
        ["#{key.to_s} > ?", Time.utc(value[:after][:year],value[:after][:month],value[:after][:day])]
      end
    end
  end

  helpers FilterUtils
end