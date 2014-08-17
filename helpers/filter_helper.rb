class Sinatra::Application
  module FilterHelper
    require 'date' 

    TASK_ATTRIBUTES = [ :created_at, :deadline, :description, :position, :priority, :status, :task_list_id, :title, :updated_at ]
    RANGE_OPTIONS   = [ :after, :before, :on ]
    TIME_FIELDS     = [ :created_at, :deadline, :updated_at ]

    class TaskFilter
      attr_accessor :conditions

      def initialize(conditions, owner_id)
        @conditions = conditions.reject {|key, val| !TASK_ATTRIBUTES.include?(key) }
        @conditions[:owner_id] = owner_id
      end

      def filter
        Task.where(parse_conditions!)
      end

      protected
        def parse_conditions!
          @conditions.each do |key, value|
            if TIME_FIELDS.include?(key)
              if value.length == 1
                if value.has_key? :on
                  @conditions[key] = parse_datetime(value[:on])
                elsif value.has_key? :after
                  @conditions[key] = ["#{key} > ?", parse_datetime(value[:after])]
                else
                  @conditions[key] = ["#{key} < ?", parse_datetime(value[:before])]
                end
              else
                @conditions[key] = (parse_datetime(value[:after])..parse_datetime(value[:before]))
              end
            end
          end
        end

        def parse_datetime(date)
          year, month, day = date[:year], date[:month], date[:day]
          Time.utc(year, month, day)
        end
    end

    def filter_resources(hash)
      tasks = TaskFilter.new(hash[:filters], hash[:user]).filter.to_a.map {|task| task.to_hash } 
      tasks.to_json
    end
  end

  helpers FilterHelper
end