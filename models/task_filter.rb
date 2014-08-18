require 'date'

class TaskFilter
  attr_accessor :conditions

  TASK_ATTRIBUTES = [ :created_at, :deadline, :description, :position, :priority, :status, :task_list_id, :title, :updated_at ]
  RANGE_OPTIONS   = [ :after, :before, :on ]
  TIME_FIELDS     = [ :created_at, :deadline, :updated_at ]

  def initialize(conditions, owner_id)
    @categorical_conditions = sanitize!(conditions).reject {|key, val| TIME_FIELDS.include?(key) }
    @time_conditions = conditions.reject {|key, value| @categorical_conditions.include?(key) }
    @scope = Task.where(owner_id: User.find(owner_id))
  end

  def filter
    tasks = @scope.where(@categorical_conditions) if @categorical_conditions
    tasks = tasks.where(parse_conditions!(@time_conditions)) if @time_conditions
  end

  protected

    def parse_conditions!(conditions)
      begin
        conditions.each do |key, value|
          if value.length == 1
            if value.has_key? :on
              conditions[key] = parse_datetime(value[:on])
            elsif value.has_key? :after
              return ["#{key.to_s} > ?", parse_datetime(value[:after])]
            else
              return ["#{key.to_s} < ?", parse_datetime(value[:before])]
            end
          else
            conditions[key] = (parse_datetime(value[:after])..parse_datetime(value[:before]))
          end
        end
      rescue NoMethodError
        nil
      end
    end

    def parse_datetime(date)
      year, month, day = date[:year], date[:month], date[:day]
      Time.utc(year, month, day)
    end

    def sanitize!(conditions)
      conditions = conditions.reject {|key, value| !TASK_ATTRIBUTES.include?(key) }
    end
end