class Sinatra::Application
  module FilterHelper
    require 'date' 

    TASK_ATTRIBUTES = [ :title, :status, :priority, :created_at, :updated_at, :task_list_id, :position, :deadline, :description ]

    class TaskFilter
      attr_accessor :conditions

      def initialize(conditions, owner_id)
        @conditions = conditions.delete_if {|key, val| !TASK_ATTRIBUTES.include?(key) }
        @conditions[:owner_id] = owner_id
      end

      def filter
        parse_conditions!
        Task.where(@conditions)
      end

      protected
        def parse_conditions!
          @conditions.each do |key, value|
            @conditions[key] = parse_time(value) if value.is_a?(Hash) && value.has_key?(:day)
          end
          @conditions
        end

        def parse_time(time)
          Date.new(time[:year], time[:month], time[:day])
        end
    end

    def filter_resources(hash)
      @filter = TaskFilter.new(hash[:filters], hash[:user])
      (@filter.filter.to_a.map {|task| task.to_hash }).to_json
    end
  end

  helpers FilterHelper
end